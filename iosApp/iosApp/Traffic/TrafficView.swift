//
//  TrafficView.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI

struct TrafficButton: View {
    @State var traffic: TrafficSummary?
    @Binding var dragAmount: CGPoint?
    var area: CGPoint = CGPoint(x: 100, y: 100)
    var clickAction: (() -> Void)? = nil
    let btnSize = CGPoint(x: 100, y: 100)
    @EnvironmentObject var dataModel: TrafficDataModel
    
    var body: some View {
        Button(action: clickAction ?? performAction) {
            ZStack {
//                Circle()
//                    .foregroundColor(.blue)
//                    .frame(width: btnSize.x, height: btnSize.y)
                Text(dataModel.traffic?.description ?? "Move Me")
                    .foregroundColor(.white)
                    .font(.system(size: 10)).background(Color.blue)
            }
        }
         // Use .none animation for glue effect
        .animation(.default, value: dragAmount)
        .position(self.dragAmount ?? CGPoint(x: area.x - 2 * btnSize.x,
                                             y: area.y - 2 * btnSize.y))
        .highPriorityGesture(  // << to do no action on drag !!
            DragGesture()
                .onChanged { self.dragAmount = $0.location})
        .onAppear {
            TrafficManager.shared.delegate = dataModel
            TrafficManager.shared.start()
        }
        .onDisappear {
            
        }
    }
    
    func performAction() {
        print("button pressed")
    }
    
}

class TrafficDataModel: ObservableObject, TrafficManagerDelegate {
    @Published var traffic: TrafficSummary? = nil
    
    init() {
        
    }
    
    func post(summary: TrafficSummary) {
        traffic = summary
        print(summary)
        // wifi:[speed:[download: 0.1 KB/s, upload: 0.0 KB/s], data:[received: 14.9 KB, sent: 13.2 KB]],
        // wwan:[speed:[download: 0.0 KB/s, upload: 0.0 KB/s], data:[received: 0.0 KB, sent: 0.0 KB]]
    }
}

