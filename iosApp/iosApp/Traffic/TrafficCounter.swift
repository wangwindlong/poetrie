//
//  TrafficCounter.swift
//  iosApp
//
//  Created by 王云龙 on 2023/9/17.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import Darwin

public struct TrafficCounter {
    
    public init() { }
    
    public var usage: TrafficPackage {
        var result: TrafficPackage = .zero
        var addrsPointer: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&addrsPointer) == 0 {
            var pointer = addrsPointer
            while pointer != nil {
                if let addrs = pointer?.pointee {
                    let name = String(cString: addrs.ifa_name)
                    if addrs.ifa_addr.pointee.sa_family == UInt8(AF_LINK) {
                        if name.hasPrefix("en") { // Wifi
                            let networkData = unsafeBitCast(addrs.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                            result.wifi.received += UInt64(networkData.pointee.ifi_ibytes)
                            result.wifi.sent += UInt64(networkData.pointee.ifi_obytes)
                        } else if name.hasPrefix("pdp_ip") { // WWAN
                            let networkData = unsafeBitCast(addrs.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                            result.wwan.received += UInt64(networkData.pointee.ifi_ibytes)
                            result.wwan.sent += UInt64(networkData.pointee.ifi_obytes)
                        }
                    }
                }
                pointer = pointer?.pointee.ifa_next
            }
            freeifaddrs(addrsPointer)
        }
        return result
    }
}
