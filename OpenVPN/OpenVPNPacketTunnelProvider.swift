//
//  PacketTunnelProvider.swift
//  OpenVPN
//
//  Created by Da Phan Van on 15/04/2022.
//

import NetworkExtension
import TunnelKitOpenVPNAppExtension
import OSLog
import TunnelKitOpenVPNProtocol
import TunnelKitOpenVPN

private let appGroup = "group.sysvpn.client.ios"

class PacketTunnelProvider: OpenVPNTunnelProvider {
    let userDefaultsShared = UserDefaults(suiteName: appGroup)
    private var connectivityTimer: Timer?
    private var dataTaskFactory: DataTaskFactory!
    private var lastConnectivityCheck: Date = Date()
    private var timerFactory: TimerFactory!
    private var nwPathMonitor: NWPathMonitor? 

    private var currentRefreshSession: String?
    var lastProviderConfiguration: [String: Any] = [:]
    var requestCert: RequestCertificateModel?

    override init() {
        os_log("INITIATE TUNNEL PROVIDER")
        super.init()
        if userDefaultsShared?.bool(forKey: "openVPNTunnelCouldBeDropped") == true {
            /*  os_log("VPN DROPPED - DISCONNECT")
             userDefaultsShared?.set(false, forKey: "openVPNTunnelCouldBeDropped")
             Task {
                 await OpenVPNManager.shared.disconnect()
             }*/
        }
        dataCountInterval = 1000
        timerFactory = TimerFactoryImplementation()
        let dataTaskFactoryGetter = { [unowned self] in dataTaskFactory! }
        setDataTaskFactory(sendThroughTunnel: true)
    }

    deinit {
        os_log("DEINITIATE TUNNEL PROVIDER")
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

    override func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        os_log("VPN START")
        if let tunnel = protocolConfiguration as? NETunnelProviderProtocol,
           let providerConfigutaion = tunnel.providerConfiguration {
            lastProviderConfiguration = providerConfigutaion
        }

        super.startTunnel(options: options) { [weak self] error in

            os_log("VPN START ERROR \(error)")
            guard let error = error else {
                completionHandler(nil)
                self?.connectionEstablished()
                return
            }
            completionHandler(error)
        }
    }


    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        os_log("STOP OPENVPN TUNNEL %{public}@ ", reason.rawValue)
        userDefaultsShared?.set(false, forKey: "openVPNTunnelCouldBeDropped")
        super.stopTunnel(with: reason, completionHandler: completionHandler)
    }

    override func sleep(completionHandler: @escaping () -> Void) {
        // stopTestingConnectivity()
        os_log("VPN SLEEP")
    }

    override func wake() {
        // startTestingConnectivity()
        // checkConnectivity()

        os_log("VPN WAKE")
    }

    private func connectionEstablished() {
        os_log("START OPENVPN TUNNEL")
        userDefaultsShared?.set(true, forKey: "openVPNTunnelCouldBeDropped")
        // certificateRefreshManager?.start { }
        startTestingConnectivity()
    }

    override func refreshConnection() {
        os_log("[] REFRESH CERT")
        refreshCert() 
    }

    private func startTestingConnectivity() {
        os_log("SETUP TESTING VPN CONNECTIVITY")
        DispatchQueue.main.async {
            self.connectivityTimer?.invalidate()
            self.connectivityTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.checkConnectivity), userInfo: nil, repeats: true)
            self.nwPathMonitor = NWPathMonitor()
            self.nwPathMonitor?.pathUpdateHandler = { path in
                self.internetAvailable = path.status == .satisfied
            }
            self.nwPathMonitor?.start(queue: .main)
        }
    }

    private func stopTestingConnectivity() {
//        DispatchQueue.main.async {
//            self.connectivityTimer?.invalidate()
//            self.connectivityTimer = nil
//            self.nwPathMonitor = nil
//        }
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
    }

    func reloadSessionAndConnect() {
        let string = (requestCert?.convertToString() ?? "") + getDNS()
        do {
            let cfg = try OpenVPN.ConfigurationParser.parsed(fromContents: string)
            let providerCfg = OpenVPN.ProviderConfiguration.init("OpenVPN", appGroup: appGroup, configuration: cfg.configuration)
            super.reloadSessionAndConnect(cfg: providerCfg)
        } catch {
            print(error)
        }
    }

    func getDNS() -> String {
        var stringData = ""

        let primaryDNSValue = (lastProviderConfiguration["primaryDNSValue"] as? String) ?? ""
        let secondaryDNSValue = (lastProviderConfiguration["secondaryDNSValue"] as? String) ?? ""
        let selectCyberSec = ((lastProviderConfiguration["selectCyberSec"] as? Bool) ?? false)

        guard let dnsCyberSec = requestCert?.dns,
              !dnsCyberSec.isEmpty, selectCyberSec else {
            if primaryDNSValue != "" {
                stringData += "dhcp-option DNS " + primaryDNSValue + "\r\n"
            }
            if secondaryDNSValue != "" {
                stringData += "dhcp-option DNS " + secondaryDNSValue + "\r\n"
            }

            return stringData
        }

        dnsCyberSec.forEach {
            stringData += "dhcp-option DNS " + $0 + "\r\n"
        }

        return stringData
    }

    private func check(url urlString: String) {
        os_log("START CHECKING VPN STATUS")
        guard let url = URL(string: urlString), let _ = url.host, internetAvailable == true else {
            os_log("QUIT CHECKING VPN CONNECTIVITY")
            return
        }
        let urlRequest = URLRequest(url: url)


        var sessionRefreshId = UUID().uuidString;
        currentRefreshSession = sessionRefreshId

        os_log("CheckVPNStatus:  refresh with id:  %{public}@", sessionRefreshId)

        let task = dataTaskFactory.dataTask(urlRequest) { data, response, error in

            if sessionRefreshId != self.currentRefreshSession {
                os_log("CheckVPNStatus: Invalid session refresh  %{public}@", sessionRefreshId)
                return
            }

            if error is POSIXError, (error as? POSIXError)?.code == .ETIMEDOUT {
                os_log("CheckVPNStatus: TIMEOUT")
                // self.refreshCert()
                self.refreshConnection() 
            } else {
                os_log("CheckVPNStatus: Success")
            }
        }
        task.resume()
    }

    private func refreshCert() {
        if internetAvailable == false {
            return
        }
        os_log("START REFRESH CERTIFICATE")


        releaseConnection()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
            if let param = self.lastProviderConfiguration["paramGetCert"] as? [String: Any],
               let header = self.lastProviderConfiguration["headerGetCert"] as? [String: String] {
                GetCertService.shared.getCert(param: param, header: header) {
                    if let result = $0 {
                        self.requestCert = result
                        if let sessionId = result.sessionId {
                            os_log("GetCertService: result api %{public}@", "\(sessionId)")
                        }
                        os_log("RELOAD VPN SESSION")

                        self.reloadSessionAndConnect()
                    } else {
                        os_log("RELOAD VPN FAILED")
                    }
                }
            }
        }
    }

    private func setDataTaskFactory(sendThroughTunnel: Bool) {
        print("Routing API requests through \(sendThroughTunnel ? "tunnel" : "URLSession").")

        dataTaskFactory = !sendThroughTunnel ?
            URLSession.shared :
            ConnectionTunnelDataTaskFactory(provider: self,
                                            timerFactory: timerFactory)
    }


}
