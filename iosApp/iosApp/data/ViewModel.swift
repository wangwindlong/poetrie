//
//  CuiModel.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import shared
import UIKit
import Photos

class ViewModel: ObservableObject {
    
    @Published var orderResponse: CuiModel?
    @Published var responseText: String?
    @Published var barCode: String?

    @Published var selectedImages: [UIImage] = []
    @Published var selectedAssets: [PHAsset] = []
    @Published var selectedResults: [ZLResultModel] = []
    @Published var isOriginal = false
    @Published var showScan = false
    @Published var hasBarcode = false
    @Published var isError = false
    @Published var errorMsg: String? = nil
    
    init() {
        
    }

    func getOrderInfo(_ barcode: String = "202311171753273") {
        print("ViewModel getOrderInfo")
        DIHelper().cuiRepository.getOrderInfo(barCode: barcode) { result, error in
            print("getOrderInfo result=\(result), error=\(error)")
            if let result {
                DispatchQueue.main.async {
                    if result.id == 0 {
                        self.responseText = "未找到货品，请重新扫码"
                    } else {
                        self.orderResponse = result
                    }
                }
            }
            else if let error = error {
                DispatchQueue.main.async{
                    self.responseText = error.localizedDescription
                }
            }
        }
    }
    
    func uploadImageUrls(_ dataModel: GalleryModel) {
        guard let order = orderResponse
//                , dataModel.items.count > 0
//                , dataModel.videoItems.count > 0
        else {
            isError = true
            errorMsg = "请拍摄图片和视频后再提交"
            return
        }
        UploadUtils.uploadPicList(items: dataModel.items) { results in
            let fcPicList = results
            var videoList = [String]()
            var largeVideoList = [String]()
            UploadUtils.uploadPicList(items: dataModel.videoItems) { results in
                videoList = results
                UploadUtils.uploadPicList(items: dataModel.largeVideoItems) { results in
                    largeVideoList = results
                    DispatchQueue.main.async{
                        self.uploadUrls(111, fcPicList, videoList, largeVideoList)
                    }
                }
            }
        }
    }
    
    func uploadUrls(_ orderId: Int64, _ fcPicList: [String], _ videoList: [String], _ largeList: [String]) {
        let params = CuiPicParams(
            id: orderId,
            fcPic: CuiPicModel(PICLIST: KotlinArray(size: Int32(fcPicList.count), init: { index in
                fcPicList[Int(truncating: index)] as NSString
        })),
            fcVideo: CuiPicModel(PICLIST: KotlinArray(size: Int32(videoList.count), init: { index in
                videoList[Int(truncating: index)] as NSString
        })),
            sring: CuiPicModel(PICLIST: KotlinArray(size: Int32(largeList.count), init: { index in
                largeList[Int(truncating: index)] as NSString
        })),
            isSring: largeList.count > 0 ? "1" : "0")
        print("ViewModel uploadImageUrls params=\(params)")
        DIHelper().cuiRepository.uploadImages(params: params) { result, error in
            print("uploadImages result=\(result), error=\(error)")
            if let result, result.code == 1 {
//                DispatchQueue.main.async {
//                    if result.id == 0 {
//                        self.responseText = "上传图片失败，请重试"
//                    } else {
//                        self.orderResponse = result
//                    }
//                }
            }
            else if let error = error {
                DispatchQueue.main.async{
                    self.responseText = error.localizedDescription
                }
            }
        }
    }
    
    
    func appendImages(_ images: [UIImage]) {
//        selectedImages.append(contentsOf: images)
    }
    
    func appendSelectedResults(_ results: [ZLResultModel]) {
//        selectedResults.append(contentsOf: results)
    }
    
    func appendSelectedResults(_ assets: [PHAsset]) {
//        selectedAssets.append(contentsOf: assets)
    }
    
    func setImages(_ images: [UIImage]) {
//        selectedImages.removeAll()
//        selectedImages.append(contentsOf: images)
    }
    
    func setSelectedResults(_ results: [ZLResultModel]) {
//        selectedResults.removeAll()
//        selectedResults.append(contentsOf: results)
    }
    
    func setSelectedResults(_ assets: [PHAsset]) {
//        selectedAssets.removeAll()
//        selectedAssets.append(contentsOf: assets)
    }
    
}
