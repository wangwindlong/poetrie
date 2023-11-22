//
//  ZLCameraView.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/21.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI
import Photos

struct CameraViewControllerWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var data: ViewModel
    @Binding var isActive: Bool
    @State var exit: Bool = false
    
    func makeUIViewController(context: Context) -> UIViewController {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { image, videoUrl in
            self.save(image: image, videoUrl: videoUrl)
            exit = true
        }
        camera.cancelBlock = {
            exit = true
        }
        camera.libraryBlock = {
            exit = true
        }
        print("CameraViewControllerWrapper makeUIViewController")
        return camera
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 更新 viewController 的属性
//        uiViewController.title = "Updated Title"
        print("CameraViewControllerWrapper updateUIViewController")
//        isActive = false
        if exit {
            guard let navController = uiViewController.navigationController else { return }
//            let vc = UIHostingController(rootView: CameraView(viewModel))
//            let vc = UIHostingController(rootView: TestContent().environmentObject(viewModel).environmentObject(GalleryModel()))
            navController.popViewController(animated: true)
//            navController.pushViewController(vc, animated: true)
        }
    }
    
    func save(image: UIImage?, videoUrl: URL?) {
        if let image = image {
            let hud = ZLProgressHUD.show(toast: .processing)
            ZLPhotoManager.saveImageToAlbum(image: image) { suc, asset in
                if suc, let asset = asset {
                    let resultModel = ZLResultModel(asset: asset, image: image, isEdited: false, index: 0)
//                    selectedResults.removeAll()
                    self.data.appendSelectedResults([resultModel])
                    self.data.appendImages([image])
                    self.data.appendSelectedResults([asset])
                } else {
                    debugPrint("保存图片到相册失败")
                }
                hud.hide()
            }
        } else if let videoUrl = videoUrl {
            let hud = ZLProgressHUD.show(toast: .processing)
            ZLPhotoManager.saveVideoToAlbum(url: videoUrl) { suc, asset in
                if suc, let asset = asset {
                    self.fetchImage(for: asset)
                } else {
                    debugPrint("保存视频到相册失败")
                }
                hud.hide()
            }
        }
    }
    
    func fetchImage(for asset: PHAsset) {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        option.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: option) { image, info in
            var downloadFinished = false
            if let info = info {
                downloadFinished = !(info[PHImageCancelledKey] as? Bool ?? false) && (info[PHImageErrorKey] == nil)
            }
            let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool ?? false)
            if downloadFinished, !isDegraded, let image = image {
                let resultModel = ZLResultModel(asset: asset, image: image, isEdited: false, index: 0)
                self.data.appendSelectedResults([resultModel])
                self.data.appendImages([image])
                self.data.appendSelectedResults([asset])
            }
        }
    }
}
