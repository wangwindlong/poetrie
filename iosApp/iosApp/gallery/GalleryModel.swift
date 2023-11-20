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
    @Published var error: String? = nil
    
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
        items.append(Item(url: nil, itemType: ItemType.empty))
    }
    
    /// Adds an item to the data collection.
    func addItem(_ item: Item) {
        if items.filter({ $0.itemType == .photo }).count >= MAX_COUNT_PHOTO {
            error = "最多只能拍\(MAX_COUNT_PHOTO)张照片"
        } else if items.filter({ $0.itemType == .video }).count >= MAX_COUNT_VIDEO {
            error = "最多只能拍\(MAX_COUNT_VIDEO)个视频"
        } else {
            items.insert(item, at: 0)
        }
    }
    
    /// Removes an item from the data collection.
    func removeItem(_ item: Item) {
        if let index = items.firstIndex(of: item), let url = item.url {
            items.remove(at: index)
            FileManager.default.removeItemFromDocumentDirectory(url: url)
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
