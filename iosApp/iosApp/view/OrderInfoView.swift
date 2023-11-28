//
//  DetailView.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/27.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

struct OrderInfoView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
//        if let order = viewModel.orderResponse {
            OrderView(order: viewModel.orderResponse)
//        } else {
//            Text("未找到信息")
//        }
    }
}

struct OrderView: View {
    let order: CuiModel?
    @State var showPhoto = false
    var body: some View {
        VStack(spacing: 0) {
            Text("标题")
                .font(.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(alignment: .leading)
                .background(.orange)
            ScrollView {
                VStack(spacing: 10) {
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                    InfoRow(label: "标签1", content: "内容1")
                }
                .padding()
            }
            
            Button(action: {
                showPhoto = true
            }) {
                Text("图片/视频补充")
                        .padding()
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .background(
                            Capsule(style: .continuous)
                                .foregroundColor(.orange)
                                .frame(width: 150, height: 50)
                        )
            }
            NavigationLink(destination: TestContent(), isActive: $showPhoto) {
                EmptyView()
            }
            .hidden()
        }
    }
}

struct InfoRow: View {
    var label: String
    var content: String
    
    var body: some View {
        HStack {
            Text(label).foregroundColor(.gray).font(.headline)
            Text(content).padding(.leading, 15)
            Spacer()
        }
    }
}
