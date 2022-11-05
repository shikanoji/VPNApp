//
//  AppSettingIP.swift
//  SysVPN
//
//  Created by Da Phan Van on 05/11/2022.
//

import Foundation

class AppSettingIP: ObservableObject {
    static let shared = AppSettingIP()

    private let appGroup = "group.sysvpn.client.ios"

    var ip = [String]()

    func update() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "AppSettingIP.timer")

    func startGetIP() {
        sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                     queue: queue)
        resumeTimer()
    }

    private func resumeTimer() {
        sourceTimer?.setEventHandler {
            Task {
                await self.updateTimer()
                self.update()
            }
        }

        sourceTimer?.schedule(deadline: .now(),
                              repeating: 30)
        sourceTimer?.resume()
    }

    private func updateTimer() async {
        await updaterServerIP()
    }

    func updaterServerIP() async {
        if let hostName = URL(string: Constant.api.root)?.host {
            let userDefaultsShared = UserDefaults(suiteName: appGroup)
            let info = await AppSettingIP.urlToIPGetHostByName(hostname: hostName)
            userDefaultsShared?.setValue(info, forKey: "server_ips")
        }
    }

    func resetIP() {
        UserDefaults(suiteName: appGroup)?.setValue([], forKey: "server_ips")
    }

    static func urlToIPGetHostByName(hostname: String) async -> [String] {
        var ipList: [String] = []

        guard let host = hostname.withCString({ gethostbyname($0) }) else {
            return ipList
        }

        guard host.pointee.h_length > 0 else {
            return ipList
        }

        var index = 0

        while host.pointee.h_addr_list[index] != nil {
            var addr = in_addr()

            memcpy(&addr.s_addr, host.pointee.h_addr_list[index], Int(host.pointee.h_length))

            guard let remoteIPAsC = inet_ntoa(addr) else {
                return ipList
            }

            ipList.append(String(cString: remoteIPAsC))

            index += 1
        }

        return ipList
    }
}
