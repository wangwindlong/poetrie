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
    static func uploadPic(img: UIImage, name: String = UUID().uuidString + ".jpg",
                          onComplete: ((QCloudUploadObjectResult?, Error?) -> Void)? = nil) {
        jk_formatter.dateFormat = "yyyy_MM_dd"
    //    let picPath = "iOS/\(Day(date: date).format(format: "yyyy-MM-dd"))/\(UUID().uuidString).jpg"
        let picPath = "iOS/\(jk_formatter.string(from: Date()))/\(name)"
        
        let put = QCloudCOSXMLUploadObjectRequest<AnyObject>()
        put.bucket = BUCKET_ID // bucket id
        put.object = picPath // 上传路径
        put.body = img.pngData() as AnyObject
        put.setFinish { res, error in
            onComplete?(res, error)
            if let error {
                print("upload object error: \(error)")
                return
            } else if let res {
                // https://jcb-1319692236.cos.ap-chengdu.myqcloud.com/iOS/test.jpg
                print("upload obj finish location=\(res.location) bucket = \(res.bucket) key=\(res.key) etag=\(res.eTag) size=\(res.size)")
            }
        }
        QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(put)
    }
    
    static func uploadPic(url: URL, onComplete: @escaping (QCloudUploadObjectResult?) -> Void) {
        jk_formatter.dateFormat = "yyyy_MM_dd"
        let picPath = "iOS/\(jk_formatter.string(from: Date()))/\(url.lastPathComponent)"
        
        let put = QCloudCOSXMLUploadObjectRequest<AnyObject>()
        put.bucket = BUCKET_ID // bucket id
        put.object = picPath // 上传路径
        put.body = try! Data(contentsOf: url) as AnyObject
        put.setFinish { res, error in
            onComplete(res)
            if let error {
                print("upload url \(url.absoluteString) error: \(error)")
            } else if let res {
                print("upload obj url finish location=\(res.location) bucket = \(res.bucket) key=\(res.key) etag=\(res.eTag) size=\(res.size)")
            }
        }
        QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(put)
    }
    
    static func uploadPicList(items: [Item], onComplete: (([String]) -> Void)? = nil) {
        realUploadPicList(items: items) { results in
            onComplete?(results)
        }
    }
    
    static func realUploadPicList(items: [Item], results: [String] = [], onComplete: @escaping ([String]) -> Void) {
        if items.count <= 0 {
            onComplete(results)
            return
        }
        guard let url = items[0].url else {
            realUploadPicList(items: Array(items[1..<items.count]), results: results, onComplete: onComplete)
            return
        }
        uploadPic(url: url) { res in
            realUploadPicList(items: Array(items[1..<items.count]),
                              results: results + (res == nil ? [] : [res!.location]),
                              onComplete: onComplete)
        }
    }
    
}


