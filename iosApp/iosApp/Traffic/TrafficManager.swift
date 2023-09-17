//
//  TrafficManager.swift
//  iosApp
//
//  Created by 王云龙 on 2023/9/17.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

public class TrafficManager {
    
    public static let shared = TrafficManager()
    
    public private(set) var interval: Double
    
    public weak var delegate: TrafficManagerDelegate?
    
    private lazy var timer: SwiftTimer = {
        let timer = SwiftTimer.repeaticTimer(interval: .fromSeconds(self.interval)) {[weak self] timer in
            self?.updateSummary()
        }
        return timer
    }()
    
    private var counter: TrafficCounter = TrafficCounter()
    
    private var summary: TrafficSummary?
    
    private init(interval: Double = 1.0) {
        self.interval = interval
    }
    
    public func reset() {
        summary = nil
    }

    public func start() {
        timer.start()
    }
    
    public func cancel() {
        timer.suspend()
    }
    
    private func updateSummary() {
        let newSummary: TrafficSummary = {
            if let summary = self.summary {
                return summary.update(by: counter.usage, time: interval)
            } else {
                return TrafficSummary(origin: counter.usage)
            }
        }()
        delegate?.post(summary: newSummary)
        summary = newSummary
    }
}

public protocol TrafficManagerDelegate: AnyObject {
    
    func post(summary: TrafficSummary)
}
