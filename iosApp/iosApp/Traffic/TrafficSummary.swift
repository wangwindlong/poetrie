//
//  TrafficSummary.swift
//  iosApp
//
//  Created by 王云龙 on 2023/9/17.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

public struct TrafficSummary {
    
    public let wifi: TrafficStatus
    public let wwan: TrafficStatus
    public let isOrigin: Bool
    
    public var speed: TrafficSpeed {
        return wifi.speed + wwan.speed
    }
    
    public var data: TrafficData {
        return wifi.data + wwan.data
    }
    
    private init(wifi: TrafficStatus, wwan: TrafficStatus, isOrigin: Bool) {
        self.wifi = wifi
        self.wwan = wwan
        self.isOrigin = isOrigin
    }
    
    public init(origin package: TrafficPackage) {
        self.wifi = TrafficStatus(origin: package.wifi)
        self.wwan = TrafficStatus(origin: package.wwan)
        self.isOrigin = true
    }
    
    public func update(by package: TrafficPackage, time interval: Double) -> TrafficSummary {
        let newWIFI = wifi.update(by: package.wifi, time: interval)
        let newWWAN = wwan.update(by: package.wwan, time: interval)
        return TrafficSummary(wifi: newWIFI, wwan: newWWAN, isOrigin: false)
    }
}

extension TrafficSummary: CustomStringConvertible {
    
    public var description: String {
        return "wifi:[\(wifi)],\nwwan:[\(wwan)]"
    }
}
