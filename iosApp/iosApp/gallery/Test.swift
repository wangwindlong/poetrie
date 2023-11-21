//
//  Test.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/20.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI

struct TestContent: View {
    @State private var isPhotoToggled = false
    @State private var isVideoToggled = false
    @State private var isToggled = false
    
    func getToggled(_ index: Int) -> Binding<Bool> {
        switch index {
        case 0: return $isPhotoToggled
        case 1: return $isVideoToggled
        default:
            return $isToggled
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0...2, id: \.self) { i in
                    PhotoRow(index: i, isToggled: getToggled(i))
                }
            }
        }
    }
}

struct PhotoRow: View {
    var index: Int
    @Binding var isToggled: Bool
    
    @EnvironmentObject var dataModel: GalleryModel
    @EnvironmentObject var viewModel: ViewModel

    private static let initialColumns = 3
    @State private var isAddingPhoto = false
    @State private var isEditing = false
    @State private var isError = false
    
    @State private var isActive: Bool = false
    

    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    @State private var numColumns = initialColumns

    
    func getTitle() -> String {
        switch index {
        case 0: return "寄拍品主图"
        case 1: return "寄拍品视频"
        default:
            return "主播讲解视频"
        }
    }
    
    func getSubTitle() -> String {
        switch index {
        case 0: return "除打光图外请尽量提供自然光下纯色背景图片"
        case 1: return "上传自然光下拍摄视频15秒左右"
        default:
            return ""
        }
    }
    
    var body: some View {
        
        VStack {
            TitleRow(title: getTitle(),
                     subTitle: getSubTitle(),
                     isToggled: $isToggled)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: gridColumns) {
                ForEach(dataModel.items) { item in
                    GeometryReader { geo in
                        if item.isPlus {
                            NavigationLink(
                                destination: CameraViewControllerWrapper(isActive: $isActive),
                                isActive: $isActive) {
                                    GridItemView(size: geo.size.width, item: item)
                            }
                        } else {
                            NavigationLink(destination: DetailView(item: item)) {
                                GridItemView(size: geo.size.width, item: item)
                            }
                        }
                    }
                    .cornerRadius(8.0)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(alignment: .topTrailing) {
                        if isEditing && !item.isPlus {
                            Button {
                                withAnimation {
                                    dataModel.removeItem(item)
                                }
                            } label: {
                                Image(systemName: "xmark.square.fill")
                                            .font(Font.title)
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, .red)
                            }
                            .offset(x: 7, y: -7)
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct TitleRow: View {
    let title: String
    let subTitle: String
    @Binding var isToggled: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
                Toggle(isOn: $isToggled) {
                    Text("是否压缩").font(.system(size: 12))
                }.scaleEffect(0.8).fixedSize()
            }
            Text(subTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 8))
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
