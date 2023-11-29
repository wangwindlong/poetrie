//
//  PreviewVideoView.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/26.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Photos
import FLAnimatedImage

struct PhotoLibraryView: UIViewRepresentable {
    @EnvironmentObject var viewModel: ViewModel
    
    func makeUIView(context: Context) -> ZLPhotoPreviewSheet {
        print("PhotoLibraryView makeUIView")
        // Custom UI
        ZLPhotoUIConfiguration.default()
//            .navBarColor(.white)
//            .navViewBlurEffectOfAlbumList(nil)
//            .indexLabelBgColor(.black)
//            .indexLabelTextColor(.white)
            .minimumInteritemSpacing(2)
            .minimumLineSpacing(2)
            .columnCountBlock { Int(ceil($0 / (428.0 / 4))) }
            .showScrollToBottomBtn(true)
        
        if ZLPhotoUIConfiguration.default().languageType == .arabic {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .unspecified
        }
        context.coordinator
        
        // Custom image editor
        ZLPhotoConfiguration.default()
            .editImageConfiguration
            
            .imageStickerContainerView(ImageStickerContainerView())
//            .tools([.draw, .clip, .mosaic, .filter])
//            .adjustTools([.brightness, .contrast, .saturation])
//            .clipRatios([.custom, .circle, .wh1x1, .wh3x4, .wh16x9, ZLImageClipRatio(title: "2 : 1", whRatio: 2 / 1)])
//            .imageStickerContainerView(ImageStickerContainerView())
//            .filters([.normal, .process, ZLFilter(name: "custom", applier: ZLCustomFilter.hazeRemovalFilter)])
        
        /*
         ZLPhotoConfiguration.default()
             .cameraConfiguration
             .devicePosition(.front)
             .allowRecordVideo(false)
             .allowSwitchCamera(false)
             .showFlashSwitch(true)
          */
        ZLPhotoConfiguration.default()
            // You can first determine whether the asset is allowed to be selected.
            .canSelectAsset { _ in true }
            .didSelectAsset { _ in }
            .didDeselectAsset { _ in }
            .noAuthorityCallback { type in
                switch type {
                case .library:
                    debugPrint("No library authority")
                case .camera:
                    debugPrint("No camera authority")
                case .microphone:
                    debugPrint("No microphone authority")
                }
            }
            .gifPlayBlock { imageView, data, _ in
                let animatedImage = FLAnimatedImage(gifData: data)
                
                var animatedImageView: FLAnimatedImageView?
                for subView in imageView.subviews {
                    if let subView = subView as? FLAnimatedImageView {
                        animatedImageView = subView
                        break
                    }
                }
                
                if animatedImageView == nil {
                    animatedImageView = FLAnimatedImageView()
                    imageView.addSubview(animatedImageView!)
                }
                
                animatedImageView?.frame = imageView.bounds
                animatedImageView?.animatedImage = animatedImage
                animatedImageView?.runLoopMode = .default
            }
            .pauseGIFBlock { $0.subviews.forEach { ($0 as? FLAnimatedImageView)?.stopAnimating() } }
            .resumeGIFBlock { $0.subviews.forEach { ($0 as? FLAnimatedImageView)?.startAnimating() } }
//            .operateBeforeDoneAction { currVC, block in
//                // Do something before select photo result callback, and then call block to continue done action.
//                block()
//            }
        
        /// Using this init method, you can continue editing the selected photo
        let ac = ZLPhotoPreviewSheet(results: viewModel.selectedResults)
        
        ac.selectImageBlock = { results, isOriginal in
            viewModel.selectedResults = results
            viewModel.selectedImages = results.map { $0.image }
            viewModel.selectedAssets = results.map { $0.asset }
            viewModel.isOriginal = isOriginal
            debugPrint("images: \(viewModel.selectedImages)")
            debugPrint("assets: \(viewModel.selectedAssets)")
            debugPrint("isEdited: \(results.map { $0.isEdited })")
            debugPrint("isOriginal: \(isOriginal)")
            
//            guard !self.selectedAssets.isEmpty else { return }
//            self.saveAsset(self.selectedAssets[0])
        }
        ac.cancelBlock = {
            debugPrint("cancel select")
        }
        ac.selectImageRequestErrorBlock = { errorAssets, errorIndexs in
            debugPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            ac.showNoAuthorityAlert()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                ZLMainAsync {
                    if status == .denied {
                        ac.showNoAuthorityAlert()
                    } else if status == .authorized {
                        ac.photoLibraryBtnClick()
                    }
                }
            }
        } else {
            ac.photoLibraryBtnClick()
        }
        return ac
    }
    
    func updateUIView(_ uiView: ZLPhotoPreviewSheet, context: Context) {
        // Update the UIView here
        print("PhotoLibraryView updateUIView")
        
    }
}
