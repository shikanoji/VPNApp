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
    
    private var countTimerBG: Int = 0
    private var appDidEnterBackgroundDate: Date?
    private var updateTimerBG = false
    
    init() {
        setup()
    }
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func applicationDidEnterBackground(_ notification: NotificationCenter) {
        appDidEnterBackgroundDate = Date()
    }

    @objc func applicationWillEnterForeground(_ notification: NotificationCenter) {
        guard let previousDate = appDidEnterBackgroundDate else { return }
        updateTimerBG = true
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
        let seconds = difference.second!
        countTimerBG += seconds
    }
    
    var stopWatchTime = "00:00:00" {
        didSet {
            self.update()
        }
    }
    
    var paused = true {
        didSet {
            self.update()
        }
    }
    
    var laps = [LapItem]() {
        didSet {
            self.update()
        }
    }
    
    private var currentLaps = [LapItem]() {
        didSet {
            self.laps = currentLaps.reversed()
        }
    }
    
    func start() {
        self.paused = !self.paused
        
        guard let _ = self.sourceTimer else {
            self.startTimer()
            return
        }
        
        self.resumeTimer()
    }
    
    func pause() {
        self.paused = !self.paused
        self.sourceTimer?.suspend()
    }
    
    func lap() {
        if let firstLap = self.laps.first {
            let difference = self.counter - firstLap.count
            self.currentLaps.append(LapItem(count: self.counter, diff: difference))
        } else {
            self.currentLaps.append(LapItem(count: self.counter))
        }
    }
    
    func reset() {
        self.stopWatchTime = "00:00:00"
        self.counter = 0
        self.currentLaps = [LapItem]()
    }
    
    func update() {
        objectWillChange.send()
    }
    
    func isPaused() -> Bool {
        return self.paused
    }
    
    private func startTimer() {
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                          queue: self.queue)
        
        self.resumeTimer()
    }
    
    private func resumeTimer() {
        self.sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        self.sourceTimer?.schedule(deadline: .now(),
                                   repeating: 1)
        self.sourceTimer?.resume()
    }
    
    private func updateTimerWithBG() {
        if updateTimerBG {
            self.counter += countTimerBG
            countTimerBG = 0
            updateTimerBG = false
            appDidEnterBackgroundDate = nil
        }
    }
    
    private func updateTimer() {
        updateTimerWithBG()
        self.counter += 1
        
        DispatchQueue.main.async {
            self.stopWatchTime = StopWatch.convertCountToTimeString(counter: self.counter)
        }
    }
}

extension StopWatch {
    struct LapItem {
        let uuid = UUID()
        let count: Int
        let stringTime: String
        
        init(count: Int, diff: Int = -1) {
            self.count = count
            
            if diff < 0 {
                self.stringTime = StopWatch.convertCountToTimeString(counter: count)
            } else {
                self.stringTime = StopWatch.convertCountToTimeString(counter: diff)
            }
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
