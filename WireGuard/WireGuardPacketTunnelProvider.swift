//
//  PacketTunnelProvider.swift
//  WireGuard
//
//  Created by Da Phan Van on 15/04/2022.
//

import NetworkExtension
import TunnelKitWireGuardAppExtension
import OSLog
import WireGuardKit
import TunnelKitWireGuardCore

private let appGroup = "group.sysvpn.client.ios"

class PacketTunnelProvider: WireGuardTunnelProvider {
    let userDefaultsShared = UserDefaults(suiteName: appGroup)
    private var connectivityTimer: Timer?
    private var dataTaskFactory: DataTaskFactory!
    private var lastConnectivityCheck: Date = Date()
    private var timerFactory: TimerFactory!
    private var nwPathMonitor: NWPathMonitor?
    private var internetAvailable: Bool?

    var lastProviderConfiguration: [String: Any] = [:]
    var selectCyberSec = false
    var primaryDNSValue = ""
    var secondaryDNSValue = ""

    var obtainCert: ObtainCertificateModel?

    override init() {
        super.init()
        timerFactory = TimerFactoryImplementation()
        let dataTaskFactoryGetter = { [unowned self] in dataTaskFactory! }
        setDataTaskFactory(sendThroughTunnel: true)
    }

    override func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        if let tunnel = protocolConfiguration as? NETunnelProviderProtocol,
           let providerConfigutaion = tunnel.providerConfiguration {
            lastProviderConfiguration = providerConfigutaion
        }
        super.startTunnel(options: options) { [weak self] error in
            guard let error = error else {
                completionHandler(nil)
                self?.connectionEstablished()
                return
            }
            completionHandler(error)
        }

    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        stopTestingConnectivity()
        super.stopTunnel(with: reason, completionHandler: completionHandler)
    }

    override func setTunnelNetworkSettings(_ tunnelNetworkSettings: NETunnelNetworkSettings?, completionHandler: ((Error?) -> Void)? = nil) {
        if let setting = tunnelNetworkSettings as? NEPacketTunnelNetworkSettings {
            if setting.ipv4Settings == nil {
                setting.ipv4Settings = NEIPv4Settings(addresses: [], subnetMasks: [])
            }

            var ips = [NEIPv4Route]()

            userDefaultsShared?.array(forKey: "server_ips")?.forEach { ip in
                if let ip = ip as? String {
                    ips.append(NEIPv4Route(destinationAddress: ip, subnetMask: "255.255.255.255"))
                }
            }

            setting.ipv4Settings?.excludedRoutes = ips
        }

        super.setTunnelNetworkSettings(tunnelNetworkSettings, completionHandler: completionHandler)
    }

    override func sleep(completionHandler: @escaping () -> Void) {
        stopTestingConnectivity()
    }

    override func wake() {
        startTestingConnectivity()
    }

    private func connectionEstablished() {
        // certificateRefreshManager?.start { }
        startTestingConnectivity()
    }

    private func startTestingConnectivity() {
        DispatchQueue.main.async {
            self.connectivityTimer?.invalidate()
            self.connectivityTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkConnectivity), userInfo: nil, repeats: false)
            self.nwPathMonitor = NWPathMonitor()
            self.nwPathMonitor?.pathUpdateHandler = { path in
                self.internetAvailable = path.status == .satisfied
            }
            self.nwPathMonitor?.start(queue: .main)
        }
    }

    private func stopTestingConnectivity() {
        DispatchQueue.main.async {
            self.connectivityTimer?.invalidate()
            self.connectivityTimer = nil
            self.nwPathMonitor = nil
        }
    }

    @objc private func checkConnectivity() {
        let timeDiff = -lastConnectivityCheck.timeIntervalSinceNow
        if timeDiff > 60 * 3 {
            print("Seems like phone was sleeping! Last connectivity check time diff: \(timeDiff)")
        } else {
            print("Last connectivity check time diff: \(timeDiff)")
        }
        check(url: "https://api64.ipify.org/")

        lastConnectivityCheck = Date()

        if let param = lastProviderConfiguration["paramGetCert"] as? [String: Any],
           let header = lastProviderConfiguration["headerGetCert"] as? [String: String] {
            os_log("GetCertService: getObtainCert")
            GetCertService.shared.getObtainCert(param: param, header: header) {
                if let result = $0 {
                    os_log("GetCertService: result %{public}s", "\(result)")
                    self.obtainCert = result
                    self.reloadSessionAndConnect()
                }
            }
        }
    }

    func reloadSessionAndConnect() {
        if let obtainCert = obtainCert {
            if let cfg = configuretionParaseFromContents(obtainCert) {
                let tunnelConfiguration = cfg.configuration.tunnelConfiguration
                super.adapter.update(tunnelConfiguration: tunnelConfiguration) { error in
                    if let error = error {
                        os_log("GetCertService: %{public}s", "\(error)")
                    }
                }
            } else {
                os_log("GetCertService: cfg error")
            }
        }
    }

    func configuretionParaseFromContents(_ obtainCer: ObtainCertificateModel) -> WireGuard.ProviderConfiguration? {
        let lines = obtainCer.convertToString().trimmedLines()
        var clientPrivateKey = ""
        var clientAddress = ""
        var dns = ""

        var serverPublicKey = ""
        var allowedIPs = ""
        var endPoint = ""

        for line in lines {
            if let privateKey = getValueParase(line, regexType: Regex.privateKey) {
                clientPrivateKey = privateKey
            }

            if let address = getValueParase(line, regexType: Regex.address) {
                clientAddress = address
            }

            if let dnsParase = getValueParase(line, regexType: Regex.dns) {
                dns = dnsParase
            }

            if let publicKey = getValueParase(line, regexType: Regex.publicKey) {
                serverPublicKey = publicKey
            }

            if let allowedIPsParase = getValueParase(line, regexType: Regex.allowedIPs) {
                allowedIPs = allowedIPsParase
            }

            if let endpoint = getValueParase(line, regexType: Regex.endpoint) {
                endPoint = endpoint
            }
        }

        do {
            var builder = try WireGuard.ConfigurationBuilder(clientPrivateKey)
            builder.addresses = [clientAddress]

            primaryDNSValue = (lastProviderConfiguration["primaryDNSValue"] as? String) ?? ""
            secondaryDNSValue = (lastProviderConfiguration["secondaryDNSValue"] as? String) ?? ""
            selectCyberSec = ((lastProviderConfiguration["selectCyberSec"] as? Bool) ?? false)

            if selectCyberSec, !obtainCer.dns.isEmpty {
                builder.dnsServers = obtainCer.dns
            } else {
                builder.dnsServers = getCustomDNS(obtainCer).count > 0 ? getCustomDNS(obtainCer) : [dns]
            }
            try builder.addPeer(serverPublicKey, endpoint: endPoint, allowedIPs: [allowedIPs])
            builder.addAllowedIP(allowedIPs, toPeer: 0)
            let cfg = builder.build()
            return WireGuard.ProviderConfiguration("WireGuard", appGroup: appGroup, configuration: cfg)
        } catch {
            print(error)
        }

        return nil
    }

    func getCustomDNS(_ obtainCer: ObtainCertificateModel) -> [String] {
        var dnsList: [String] = []
        let dnsCyberSec = obtainCer.dns
        guard !dnsCyberSec.isEmpty else {
            if AppSetting.shared.primaryDNSValue != "" {
                dnsList.append(AppSetting.shared.primaryDNSValue)
            }
            if AppSetting.shared.secondaryDNSValue != "" {
                dnsList.append(AppSetting.shared.secondaryDNSValue)
            }
            return dnsList
        }
        return dnsCyberSec
    }

    func getValueParase(_ line: String, regexType: NSRegularExpression) -> String? {
        var valueParase: String? = nil
        regexType.enumerateArguments(in: line) {
            if $0.count > 1 {
                valueParase = $0[1]
            }
        }
        return valueParase
    }

    struct Regex {
        static let privateKey = NSRegularExpression("PrivateKey = (.*)")
        static let address = NSRegularExpression("Address = (.*)")
        static let dns = NSRegularExpression("DNS = +[\\d\\.]+( +[\\d\\.]+){0,2}")
        static let publicKey = NSRegularExpression("PublicKey = (.*)")
        static let allowedIPs = NSRegularExpression("AllowedIPs = (.*)")
        static let endpoint = NSRegularExpression("Endpoint = (.*)")
    }

    private func check(url urlString: String) {
        guard let url = URL(string: urlString), let _ = url.host, internetAvailable == true else {
            print("Can't get API endpoint hostname.")
            return
        }
        let urlRequest = URLRequest(url: url)

        let task = dataTaskFactory.dataTask(urlRequest) { data, response, error in
            if error is POSIXError, (error as? POSIXError)?.code == .ETIMEDOUT {
//                Task {
//                    await WireGuardManager.shared.disconnect()
//                }
//                if let param = self.lastProviderConfiguration["paramGetCert"] as? [String: Any],
//                   let header = self.lastProviderConfiguration["headerGetCert"] as? [String: String] {
//                    GetCertService.shared.getObtainCert(param: param, header: header) {
//                        if let result = $0 {
//                            os_log("GetCertService: result %{public}s", "\(result)")
//                        }
//                    }
//                }

            }
        }
        task.resume()
    }

    private func setDataTaskFactory(sendThroughTunnel: Bool) {
        print("Routing API requests through \(sendThroughTunnel ? "tunnel" : "URLSession").")

        dataTaskFactory = !sendThroughTunnel ?
            URLSession.shared :
            ConnectionTunnelDataTaskFactory(provider: self,
                                            timerFactory: timerFactory)
    }
}
