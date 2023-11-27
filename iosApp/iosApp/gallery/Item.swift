//
//  Item.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct Item: Identifiable {

    let id = UUID()
    let url: URL?
    var image: UIImage? = nil
    var itemType: ItemType = .photo
    var uploadUrl: String? = nil

    init(url: URL?) {
        self.url = url
    }
    
    init(url: URL?, itemType: ItemType = .photo) {
        self.url = url
        self.itemType = itemType
    }
    
    init(url: URL?, image: UIImage?, itemType: ItemType = .photo) {
        self.url = url
        self.image = image
        self.itemType = itemType
    }
}

extension Item {
    var isPlus: Bool {
        itemType == .empty
    }
    
    var isVideo: Bool {
        itemType == .video
    }
}

enum ItemType {
    case photo
    case video
    case empty
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
