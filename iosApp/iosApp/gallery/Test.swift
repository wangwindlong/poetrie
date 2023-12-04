//
//  Test.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/20.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI
import shared
import PhotosUI
import CoreTransferable

struct TestContent: View {
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var dataModel: GalleryModel
    @State private var isPhotoToggled = false
    @State private var isVideoToggled = false
    @State private var isToggled = false
    @State var itemSize: CGSize = CGSize()
    
    @State private var selectedImages: [UIImage] = []
       @State private var selectedVideo: URL?
    
    func getToggled(_ index: Int) -> Binding<Bool> {
        switch index {
        case 0: return $isPhotoToggled
        case 1: return $isVideoToggled
        default:
            return $isToggled
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    //ForEach(0...2, id: \.self) { i in }
                    PhotoRow(index: 0, isToggled: getToggled(0), itemSize: $itemSize)
                    VideoRow(isToggled: getToggled(1), itemSize: $itemSize)
                    LargeVideoRow(isToggled: getToggled(2), itemSize: $itemSize)
                    
                }
            }.onAppear() {
                print("TestContent onAppear")
            }
            Button {
//                model.camera.switchCaptureDevice()
//                if let order = viewModel.orderResponse {
                    viewModel.uploadImageUrls(dataModel)
//                }
            } label: {
                Text("确认提交")
                        .padding()
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .background(
                            Capsule(style: .continuous)
                                .foregroundColor(.orange)
                                .frame(width: 150, height: 50)
                        )
            }
            NavigationLink(destination: MultipleSelectView(), isActive: $viewModel.photoLibrary) {
                TTT()
            }
            ImagePicker(selectedImages: $selectedImages)
                            .frame(height: 200)

                        VideoPicker(selectedVideo: $selectedVideo)
                            .frame(height: 200)
//            Button("Select Image") {
//                            let picker = UIImagePickerController()
//                            picker.delegate = self
//                            picker.sourceType = .photoLibrary
//                            present(picker, animated: true)
//                        }
        }
    }
}

struct TTT: View {
    var body: some View {
        
        Text("这个是测试")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 8))
            .frame(maxWidth: .infinity)
//                    .foregroundColor(.white)
            .multilineTextAlignment(.leading)
            .onAppear() {
                print("TTT body")
            }
    }
}

struct MultipleSelectView: View {
    @State var images: [UIImage] = []
    @State var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            ForEach(images, id:\.cgImage){ image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            Spacer()
            PhotosPicker(selection: $selectedItems, matching: .images) {
                Text("Pick Photo")
            }
            .onChange(of: selectedItems) { selectedItems in
                 images = []
                 for item in selectedItems {
                     item.loadTransferable(type: Data.self) { result in
                         switch result {
                         case .success(let imageData):
                             if let imageData {
                                 self.images.append(UIImage(data: imageData)!)
                             } else {
                                 print("No supported content type found.")
                             }
                         case .failure(let error):
                             print(error)
                         }
                     }
                 }
             }
        }
    }
}

struct PhotoRow: View {
    var index: Int
    @Binding var isToggled: Bool
    @Binding var itemSize: CGSize

    private static let initialColumns = 3
    @State private var isAddingPhoto = false
    @State private var isEditing = false
    @State private var isError = false
    
    @EnvironmentObject var dataModel: GalleryModel

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
    
      func getToggleTitle() -> String {
          switch index {
          case 0: return "九宫格"
          default:
              return "是否压缩"
          }
      }
    init(index: Int, isToggled: Binding<Bool>, itemSize: Binding<CGSize>) {
        self.index = index
        self._isToggled = isToggled
        self._itemSize = itemSize
    }
    
    var body: some View {
        VStack {
            TitleRow(title: getTitle(),
                     subTitle: getSubTitle(),
                     toggleLabel: getToggleTitle(),
                     isToggled: $isToggled)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: gridColumns) {
                ForEach(dataModel.items) { item in
                    RowItem(item: item)
                }
            }
            .padding()
        }
        .padding()
//        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct VideoRow: View {
    @Binding var isToggled: Bool
    @Binding var itemSize: CGSize
    @EnvironmentObject var dataModel: GalleryModel
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            TitleRow(title: "寄拍品视频",
                     subTitle: "上传自然光下拍摄视频15秒左右",
                     isToggled: $isToggled)
            .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(dataModel.videoItems) { item in
                    RowItem(item: item, type: 1)
                }
            }.padding()
        }
        .padding()
//        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct LargeVideoRow: View {
    @Binding var isToggled: Bool
    @Binding var itemSize: CGSize
    @EnvironmentObject var dataModel: GalleryModel
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            TitleRow(title: "主播讲解视频",
                     subTitle: nil,
                     isToggled: $isToggled)
            .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(dataModel.largeVideoItems) { item in
                    RowItem(item: item, type: 2)
                }
            }.padding()
        }
        .padding()
//        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct RowItem: View {
    var item: Item
    var type: Int = 0
    @EnvironmentObject var dataModel: GalleryModel
    
    var body: some View {
        GeometryReader { geo in
            if item.isPlus {
                NavigationLink(
                    destination: CameraViewControllerWrapper(onlyVideo: type != 0)
                        .navigationBarTitle(type == 0 ? "拍照" : "视频")) {
                            GridItemView(size: geo.size.width, item: item)
                        }.onAppear {
//                                        itemSize = geo.size
                        }
            } else {
                NavigationLink(destination: DetailView(item: item)) {
                    GridItemView(size: geo.size.width, item: item)
                }.onAppear {
//                                itemSize = geo.size
                }
            }
        }
        .cornerRadius(8.0)
        .aspectRatio(1, contentMode: .fit)
        .overlay(alignment: .topTrailing) {
            if !item.isPlus {
                Button {
                    withAnimation {
                        dataModel.removeItem(item, type: type)
                    }
                } label: {
                    Image(systemName: "xmark.square.fill")
                                .font(Font.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .red)
                }
                .offset(x: 8, y: -8)
            }
        }
    }
}

struct TitleRow: View {
    let title: String
    let subTitle: String?
    var toggleLabel: String = "是否压缩"
    @Binding var isToggled: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12))
//                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
                Toggle(isOn: $isToggled) {
                    Text(toggleLabel).font(.system(size: 12))
                }.scaleEffect(0.8).fixedSize()
            }
            if let subTitle, !subTitle.isEmpty {
                Text(subTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 8))
                    .frame(maxWidth: .infinity)
//                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
