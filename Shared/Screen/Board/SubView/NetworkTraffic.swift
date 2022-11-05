//
//  ConnectButtonViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/10/2022.
//

import Foundation
import TunnelKitManager

class NetworkTraffic: ObservableObject {
    static let shared = NetworkTraffic()
    
    var uploadSpeed: String = "0 KB"
    var downloadSpeed: String = "0 KB"
    
    func update() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    var timeString: String = "00:00:00" {
        didSet {
            update()
        }
    }
    
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "NetworkTraffic.timer")
    
    func startGetTraffic() {
        sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                     queue: queue)
        resumeTimer()
    }
    
    private func resumeTimer() {
        sourceTimer?.setEventHandler {
            Task {
                await self.updateTimer()
            }
        }
        
        sourceTimer?.schedule(deadline: .now(),
                              repeating: 1)
        sourceTimer?.resume()
    }
    
    private func updateTimer() async {
        DispatchQueue.main.async {
            self.timeString = self.getTime(now: Date().timeIntervalSince1970)
        }
        
        await updateTraffic()
    }
    
    private func updateTraffic() async {
        let dataUsage = await countDataUsageInfo(SystemDataUsage.lastestVpnUsageInfo)
        uploadSpeed = dataUsage.displayString(for: dataUsage.sent)
        downloadSpeed = dataUsage.displayString(for: dataUsage.received)
    }
    
    func countDataUsageInfo(_ lastDataUsage: SingleDataUsageInfo) async -> SingleDataUsageInfo {
        let dataUsage = await SystemDataUsage.vpnDataUsageInfo()
        let received =  dataUsage.received > lastDataUsage.received ? (dataUsage.received - lastDataUsage.received) :
            (lastDataUsage.received - dataUsage.received)
        let sent =  dataUsage.sent > lastDataUsage.sent ? (dataUsage.sent - lastDataUsage.sent) :
            (lastDataUsage.sent - dataUsage.sent)
        return SingleDataUsageInfo(received: received, sent: sent)
    }
    
    private func getTime(now: Double) -> String {
        let startTimeDate = AppSetting.shared.saveTimeConnectedVPN ?? Date()
         
        let diff = getStartTimeDouble(startTimeDate)
        
        if diff <= 0 {
            return "00:00:00"
        }
       
        let hour = floor(diff / 60 / 60)
        let min = floor((diff - hour * 60 * 60) / 60)
        let second = floor(diff - (hour * 60 * 60 + min * 60))
         
        return .init(format: "%02d:%02d:%02d", Int(hour), Int(min), Int(second))
    }
    
    func getStartTimeDouble(_ startTimeDate: Date) -> Double {
        if AppSetting.shared.isConnectedToVpn {
            let time = Date().seconds(from: startTimeDate)
            return Double(time)
        }
        return 0
    }
    
    func stopBitrateMonitor() {
    }
}
