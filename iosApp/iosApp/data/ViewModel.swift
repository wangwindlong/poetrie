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
    init() {
        
    }
    @Published var orderResponse: CuiModel?
    @Published var responseText: String?
    @Published var barCode: String?

    @Published var selectedImages: [UIImage] = []
    @Published var selectedAssets: [PHAsset] = []
    @Published var selectedResults: [ZLResultModel] = []
    @Published var isOriginal = false

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
    
    func appendImages(_ images: [UIImage]) {
        selectedImages.append(contentsOf: images)
    }
    
    func appendSelectedResults(_ results: [ZLResultModel]) {
        selectedResults.append(contentsOf: results)
    }
    
    func appendSelectedResults(_ assets: [PHAsset]) {
        selectedAssets.append(contentsOf: assets)
    }
    
    func setImages(_ images: [UIImage]) {
        selectedImages.removeAll()
        selectedImages.append(contentsOf: images)
    }
    
    func setSelectedResults(_ results: [ZLResultModel]) {
        selectedResults.removeAll()
        selectedResults.append(contentsOf: results)
    }
    
    func setSelectedResults(_ assets: [PHAsset]) {
        selectedAssets.removeAll()
        selectedAssets.append(contentsOf: assets)
    }
    
}
