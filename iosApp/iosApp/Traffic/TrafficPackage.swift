//
//  TrafficPackage.swift
//  iosApp
//
//  Created by 王云龙 on 2023/9/17.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
public struct TrafficPackage {
    
    public var wwan: TrafficData
    public var wifi: TrafficData
    
    public static var zero: TrafficPackage {
        return TrafficPackage(wwan: .zero, wifi: .zero)
    }
}

extension TrafficPackage: CustomStringConvertible {
    
    public var description: String {
        return "wwan:\(wwan), wifi:\(wifi)"
    }
}
