//
//  DetailView.swift
//  iosApp
//
//  Created by 王云龙 on 2023/11/19.
//  Copyright © 2023 orgName. All rights reserved.
//

import AVKit
import SwiftUI
import AVFoundation

struct DetailView: View {
    let item: Item
    @State var player: AVPlayer? = nil
    @State var isPlaying: Bool = false

    var body: some View {
        if item.isVideo {
            // 显示视频预览
            ZStack {
                GeometryReader { geo in
                    if let player {
                        VideoPlayer(player: player).onAppear {
                            player.play()
                        }
//                        Button {
//                            isPlaying ? player.pause() : player.play()
//                            isPlaying.toggle()
//                            player.seek(to: .zero)
//                        } label: {
//                            Image(systemName: isPlaying ? "stop" : "play")
//                                .padding()
//                        }.frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                    }
                }
                
            }.onAppear {
                if let url = item.url {
                    player = AVPlayer(url: url)
                }
            }
        } else {
            AsyncImage(url: item.url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        if let url = Bundle.main.url(forResource: "mushy1", withExtension: "jpg") {
            DetailView(item: Item(url: url))
        }
    }
}
