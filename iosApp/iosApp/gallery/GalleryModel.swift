//
//  GalleryModel.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI

class GalleryModel: ObservableObject {
    
    @Published var items: [Item] = []
    @Published var videoItems: [Item] = []
    @Published var largeVideoItems: [Item] = []
    @Published var error: String? = nil
    let maxCount = 9
    
    init() {
        if let documentDirectory = FileManager.default.documentDirectory {
            let urls = FileManager.default.getContentsOfDirectory(documentDirectory).filter { $0.isImage }
            for url in urls {
                let item = Item(url: url, itemType: ItemType.photo)
                items.append(item)
            }
        }
        
        if let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: nil) {
            for url in urls {
                let item = Item(url: url, itemType: ItemType.photo)
                items.append(item)
            }
        }
        if items.count < MAX_COUNT_PHOTO {
            items.append(Item(url: nil, itemType: .empty))
        }
        if videoItems.count < MAX_COUNT_VIDEO {
            videoItems.append(Item(url: nil, itemType: .empty))
        }
        if largeVideoItems.count < MAX_COUNT_VIDEO {
            largeVideoItems.append(Item(url: nil, itemType: .empty))
        }
    }
    
    /// Adds an item to the data collection. type :0图片 1：短视频 2：长视频
    func addItem(_ item: Item, type: Int = 0) {
        if type == 0 {
            addPhoto(item)
        } else if type == 1 {
            addVideo(item)
        } else if type == 2  {
            addLargeVideo(item)
        }
    }
    
    private func addPhoto(_ item: Item) {
        if items.filter({ $0.itemType == .photo }).count >= MAX_COUNT_PHOTO {
            error = "最多只能拍\(MAX_COUNT_PHOTO)张照片"
        } else {
            items.insert(item, at: 0)
        }
        if items.count > MAX_COUNT_PHOTO {
            items.removeLast()
        }
    }
    
    private func addVideo(_ item: Item) {
        if videoItems.filter({ $0.itemType == .video }).count >= MAX_COUNT_VIDEO {
            error = "最多只能拍\(MAX_COUNT_VIDEO)个视频"
        } else {
            videoItems.insert(item, at: 0)
        }
        if videoItems.count > MAX_COUNT_VIDEO {
            videoItems.removeLast()
        }
    }
    
    private func addLargeVideo(_ item: Item) {
        if largeVideoItems.filter({ $0.itemType == .video }).count >= MAX_COUNT_VIDEO {
            error = "最多只能选择\(MAX_COUNT_VIDEO)个视频"
        } else {
            largeVideoItems.insert(item, at: 0)
        }
        if largeVideoItems.count > MAX_COUNT_VIDEO {
            largeVideoItems.removeLast()
        }
    }
    
    /// Removes an item from the data collection.
    func removeItem(_ item: Item, type: Int = 0) {
        if type == 0 {
            removePhoto(item)
        } else if type == 1 {
            removeVideo(item)
        } else {
            removeLargeVideo(item)
        }
    }
    
    func getAllItems() -> [Item] {
        return items + videoItems + largeVideoItems
    }
    
    private func removePhoto(_ item: Item) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
            if let url = item.url {
                FileManager.default.removeItemFromDocumentDirectory(url: url)
            }
        }
        if items.last?.isPlus != true {
            items.append(Item(url: nil, itemType: .empty))
        }
    }
    
    private func removeVideo(_ item: Item) {
        if let index = videoItems.firstIndex(of: item) {
            videoItems.remove(at: index)
            if let url = item.url {
                FileManager.default.removeItemFromDocumentDirectory(url: url)
            }
        }
        if videoItems.last?.isPlus != true {
            videoItems.append(Item(url: nil, itemType: .empty))
        }
    }
    
    private func removeLargeVideo(_ item: Item) {
        if let index = largeVideoItems.firstIndex(of: item) {
            largeVideoItems.remove(at: index)
            if let url = item.url {
                FileManager.default.removeItemFromDocumentDirectory(url: url)
            }
        }
        if largeVideoItems.last?.isPlus != true {
            largeVideoItems.append(Item(url: nil, itemType: .empty))
        }
    }
    
    
}

extension URL {
    /// Indicates whether the URL has a file extension corresponding to a common image format.
    var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "heic"]
        return imageExtensions.contains(self.pathExtension)
    }
}
