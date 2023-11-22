//
//  AppDelegate.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import QCloudCOSXML

class AppDelegate: NSObject, UIApplicationDelegate, QCloudSignatureProvider {
    var isInited: Bool = false
    
    func initQCloud() {
        let config = QCloudServiceConfiguration.init()
        let endpoint = QCloudCOSXMLEndPoint.init()
        endpoint.regionName = "ap-chengdu" // bucket region
        endpoint.useHTTPS = true
        config.endpoint = endpoint
        config.signatureProvider = self
        QCloudCOSXMLService.registerDefaultCOSXML(with: config)
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(
            with: config)
//        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
//            UploadUtils.updatePic(img: UIImage(named: "AppIcon")!)
//        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        initQCloud()
//        isInited = true
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        isInited = false
    }
    
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        
        guard !isInited else {
            return
        }
        isInited = true
        let credential = QCloudCredential.init()
        credential.secretID = SECRET_ID // 密钥ID
        credential.secretKey = SECRET_KEY // 密钥secret
        let creator = QCloudAuthentationV5Creator.init(credential: credential)
        let signature = creator?.signature(forData: urlRequst)
        continueBlock(signature, nil)
    }
}



