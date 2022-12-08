//
//  PacketTunnelProvider.swift
//  WireGuard
//
//  Created by Da Phan Van on 15/04/2022.
//

import NetworkExtension
import TunnelKitWireGuardAppExtension
import OSLog

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
            self.connectivityTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkConnectivity), userInfo: nil, repeats: true)
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
//        check(url: "https://api64.ipify.org/")

//        GetCertService.shared.getCert()

        getCert()

        lastConnectivityCheck = Date()
    }

    private func check(url urlString: String) {
        guard let url = URL(string: urlString), let _ = url.host, internetAvailable == true else {
            print("Can't get API endpoint hostname.")
            return
        }
        let urlRequest = URLRequest(url: url)

        let task = dataTaskFactory.dataTask(urlRequest) { data, response, error in
            if error is POSIXError, (error as? POSIXError)?.code == .ETIMEDOUT {
                Task {
                    await WireGuardManager.shared.disconnect()
                }
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

    func getCert() {
        os_log("GetCertService")
        let access = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        os_log("GetCertService: accessToken %{public}s", "\(access)")
        os_log("GetCertService: headerGetCert %{public}s", "\(AppSetting.shared.headerGetCert)")
        os_log("GetCertService ----")

        if let url = URL(string: Constant.api.root + Constant.api.path.requestCertificate) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"

            if let httpBody = try? JSONSerialization.data(withJSONObject: AppSetting.shared.paramGetCert, options: [.prettyPrinted]) {
                urlRequest.httpBody = httpBody
            }

            os_log("GetCertService: convert %{public}s", "\(AppSetting.shared.headerGetCert)")

            urlRequest.allHTTPHeaderFields = AppSetting.shared.headerGetCert

            let session = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                os_log("GetCertService: Success")
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

                        os_log("GetCertService: convert %{public}s", "\(json ?? nil)")
                    } catch {

                    }
                }

                if let error = error {
                    os_log("GetCertService: error %{public}s", "\(error)")
                }
            }

            session.resume()
        }
    }
}
