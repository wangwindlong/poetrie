//
//  TrafficData.swift
//  iosApp
//
//  Created by 王云龙 on 2023/9/17.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

public struct TrafficData {
    
    public var received: UInt64 // btyes
    public var sent: UInt64 // btyes
    
    public init(received: UInt64, sent: UInt64) {
        self.received = received
        self.sent = sent
    }
    
    public static var zero: TrafficData {
        return TrafficData(received: 0, sent: 0)
    }
    
    public var total: UInt64 {
        return received + sent
    }
}

extension TrafficData: CustomStringConvertible {
    
    public var description: String {
//        return "received: \(received.double.unitString), sent: \(sent.double.unitString)"
        return "收:\(received.double.unitString), 发:\(sent.double.unitString)"
    }
}

public func +(lhs: TrafficData, rhs: TrafficData) -> TrafficData {
    var result = lhs
    result.received += rhs.received
    result.sent += rhs.sent
    return result
}

public func -(lhs: TrafficData, rhs: TrafficData) -> TrafficData {
    var result = lhs
    if result.received > rhs.received {
        result.received -= rhs.received
    } else {
        result.received = 0
    }
    if result.sent > rhs.sent {
        result.sent -= rhs.sent
    } else {
        result.sent = 0
    }
    return result
}
