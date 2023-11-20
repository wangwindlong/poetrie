//
//  UploadUtils.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import QCloudCOSXML

enum UploadUtils {
    
    static func updatePic(img: UIImage) {
    //    let picPath = "iOS/\(Day(date: date).format(format: "yyyy-MM-dd"))/\(UUID().uuidString).jpg"
        let picPath = "iOS/test2.jpg"
        
        let put = QCloudCOSXMLUploadObjectRequest<AnyObject>()
        put.bucket = BUCKET_ID // bucket id
        put.object = picPath // 上传路径
        put.body = img.pngData() as AnyObject
        put.setFinish { res, error in
            if let error {
                print("upload object error: \(error)")
                return
            } else if let res {
                // https://jcb-1319692236.cos.ap-chengdu.myqcloud.com/iOS/test.jpg
                print("upload obj finish location=\(res.location) bucket = \(res.bucket) key=\(res.key) etag=\(res.eTag) size=\(res.size)")
//                let url =
            }
        }
        QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(put)
    }
}


