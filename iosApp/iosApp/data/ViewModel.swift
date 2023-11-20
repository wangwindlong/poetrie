//
//  CuiModel.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import shared

class ViewModel: ObservableObject {
    init() {
        
    }
    @Published var orderResponse: CuiModel?
    @Published var responseText: String?
    @Published var barCode: String?
    
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
    
}
