//
//  GridItemView.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct GridItemView: View {
    let size: Double
    let item: Item

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = item.image {
                Image(uiImage: image).frame(width: size, height: size)
            } else if let url = item.url {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: size, height: size)
            } else {
                ZStack{}
                .frame(width: size , height: size)
                .cornerRadius(8)
                .background(Color.gray)
                .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundColor(Color.clear).padding(5)
                )
                .overlay(Image(systemName: "plus")
                    .scaledToFit())
            }
        }.onAppear {
            print("GridItemView size = \(size)")
        }
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        if let url = Bundle.main.url(forResource: "mushy1", withExtension: "jpg") {
            GridItemView(size: 50, item: Item(url: url))
        }
    }
}
