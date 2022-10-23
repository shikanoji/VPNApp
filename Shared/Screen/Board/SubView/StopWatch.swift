//
//  StopWatch.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 24/12/2021.
//

import Combine
import Foundation
import SwiftUI

class StopWatch: ObservableObject {
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "stopwatch.timer")
    private var counter: Int = 0
    
    private var saveTimeConnectedVPN: Date? = AppSetting.shared.saveTimeConnectedVPN ?? Date()
    
    var stopWatchTime = "00:00:00" {
        didSet {
            update()
        }
    }
    
    var paused = true {
        didSet {
            update()
        }
    }
    
    func start() {
        paused = !paused
        
        guard let _ = sourceTimer else {
            startTimer()
            return
        }
        
        resumeTimer()
    }
    
    func pause() {
        paused = !paused
        sourceTimer?.suspend()
    }
    
    func reset() {
        stopWatchTime = "00:00:00"
        counter = 0
    }
    
    func update() {
        objectWillChange.send()
    }
    
    func isPaused() -> Bool {
        return paused
    }
    
    private func startTimer() {
        sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                     queue: queue)
        resumeTimer()
    }
    
    private func resumeTimer() {
        sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        sourceTimer?.schedule(deadline: .now(),
                              repeating: 1)
        sourceTimer?.resume()
    }
    
    private func getTime() -> Int {
        if AppSetting.shared.isConnectedToVpn {
            let time = Date().seconds(from: saveTimeConnectedVPN ?? Date())
            return Int(time)
        }
        return 0
    }
    
    private func updateTimer() {
        counter = getTime()

        DispatchQueue.main.async {
            self.stopWatchTime = StopWatch.convertCountToTimeString(counter: self.counter)
        }
    }
}

extension StopWatch {
    static func convertCountToTimeString(counter: Int) -> String {
        let seconds = (counter % 3600) % 60
        let minutes = (counter % 3600) / 60
        let hours = counter / 3600
        
        var secondsString = "\(seconds)"
        var minutesString = "\(minutes)"
        var hoursString = "\(hours)"
        
        if seconds < 10 {
            secondsString = "0" + secondsString
        }
        
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        
        if hours < 10 {
            hoursString = "0" + hoursString
        }
        
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
