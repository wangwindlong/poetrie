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
    @EnvironmentObject var galleryModel: GalleryModel
    var onlyVideo: Bool = false
    var isCompress: Bool = true
    @State var exit: Bool = false
    var index: Int = 0
    
    func makeUIViewController(context: Context) -> UIViewController {
        ZLPhotoConfiguration.default()
            .cameraConfiguration
            .allowRecordVideo(onlyVideo)
            .allowTakePhoto(!onlyVideo)
            .allowSwitchCamera(false)
            .showFlashSwitch(true)
            .sessionPreset(.hd1280x720)
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
        camera.isCompress = {
            isCompress
        }
        print("CameraViewControllerWrapper makeUIViewController")
        return camera
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 更新 viewController 的属性
//        uiViewController.title = "Updated Title"
        print("CameraViewControllerWrapper updateUIViewController")
        if exit {
            guard let navController = uiViewController.navigationController else { return }
//            let vc = UIHostingController(rootView: CameraView(viewModel))
//            let vc = UIHostingController(rootView: TestContent().environmentObject(viewModel).environmentObject(GalleryModel()))
            navController.popViewController(animated: true)
//            navController.pushViewController(vc, animated: true)
        }
    }
    
    func save(image: UIImage?, videoUrl: URL?) {
        print("save image")
        if let image = image {
            let hud = ZLProgressHUD.show(toast: .processing)
            ZLPhotoManager.saveImageToAlbum(image: image) { suc, asset in
                if suc, let asset = asset {
                    let resultModel = ZLResultModel(asset: asset, image: image, isEdited: false, index: 0)
//                    selectedResults.removeAll()
                    self.data.appendSelectedResults([resultModel])
                    self.data.appendImages([image])
                    self.data.appendSelectedResults([asset])
                    self.galleryModel.addItem(Item(url: asset.getPhotoURL(), itemType: .photo))
                } else {
                    debugPrint("保存图片到相册失败")
                }
                hud.hide()
            }
        } else if let videoUrl = videoUrl {
            let hud = ZLProgressHUD.show(toast: .processing)
            ZLPhotoManager.saveVideoToAlbum(url: videoUrl) { suc, asset in
                if suc, let asset = asset {
                    self.fetchImage(for: asset, videoUrl: videoUrl)
                } else {
                    debugPrint("保存视频到相册失败")
                }
                hud.hide()
            }
        }
    }
    
    func fetchImage(for asset: PHAsset, videoUrl: URL) {
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
                self.galleryModel.addItem(Item(url: videoUrl, image: image, itemType: .video), type: 1)
            }
        }
    }
}

extension PHAsset {
    func getPhotoURL() -> URL? {
        let source = PHAssetResource.assetResources(for: self).last
        let url =  source?.value(forKey: "privateFileURL") as? URL
        print("PHAsset getURL=\(url)")
        return url
    }
}
