//
//  ConnectButtonViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/10/2022.
//

import Foundation
import TunnelKitManager

class ConnectButtonViewModel: ObservableObject {
    @Published var uploadSpeed: String = "0"
    @Published var downloadSpeed: String = "0"
    
    var firstLoadData = true
    var lastDataUsage: DataUsageInfo = DataUsageInfo()
    var speedTimer: DispatchSourceTimer?
    
    func getSpeedRealTime() {
        firstLoadData = true
        let queue = DispatchQueue.main
        speedTimer = DispatchSource.makeTimerSource(queue: queue)
        speedTimer!.schedule(deadline: .now(), repeating: .seconds(1))
        speedTimer!.setEventHandler { [weak self] in
            guard let `self` = self else {
                return
            }
            let sent = SystemDataUsage.dataSent
            let received = SystemDataUsage.dataReceived
            
            let uploadSpeed = abs(Int(sent) - Int(self.lastDataUsage.sent))
            let downloadSpeed = abs(Int(received) - Int(self.lastDataUsage.received))
            if self.firstLoadData {
                self.firstLoadData = false
            } else {
                self.uploadSpeed = UInt(uploadSpeed).descriptionAsDataUnit
                self.downloadSpeed = UInt(downloadSpeed).descriptionAsDataUnit
            }
            
            self.lastDataUsage = DataUsageInfo(received: received, sent: sent)
        }
        speedTimer!.resume()
    }
    
    func stopSpeedTimer() {
        speedTimer = nil
    }
    
    deinit {
        stopSpeedTimer()
    }
}
