//
//  TrafficStatus.swift
//  iosApp
//
//  Created by 王云龙 on 2023/9/17.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

public struct TrafficStatus {
    
    public let speed: TrafficSpeed
    public let data: TrafficData
    public let origin: TrafficData
    
    private init(speed: TrafficSpeed, data: TrafficData, origin: TrafficData) {
        self.speed = speed
        self.data = data
        self.origin = origin
    }
    
    public init(origin data: TrafficData) {
        self.speed = .zero
        self.data = .zero
        self.origin = data
    }
    
    public func update(by data: TrafficData, time interval: Double) -> TrafficStatus {
        let speed = TrafficSpeed(old: self.data, new: data - origin, interval: interval)
        return TrafficStatus(speed: speed, data: data - origin, origin: origin)
    }
}

extension TrafficStatus: CustomStringConvertible {
    
    public var description: String {
//        return "speed:[\(speed)], data:[\(data)]"
        return "\(speed) \n \(data)"
    }
}
