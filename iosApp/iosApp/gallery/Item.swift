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
    var itemType: ItemType = .photo

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
