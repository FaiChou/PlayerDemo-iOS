//
//  KSVideoPage.swift
//  PlayerDemoIOS
//
//  Created by FaiChou on 2023/8/15.
//

import SwiftUI
import KSPlayer

struct KSVideoPage: View {
    let url: URL
//    @StateObject var playerCoordinator = KSVideoPlayer.Coordinator()
    var body: some View {
        VStack {
//            KSVideoPlayer(coordinator: playerCoordinator, url: url, options: KSOptions())
//                .onStateChanged { playerLayer, state in
//                    if state == .readyToPlay {
//                        playerLayer.play()
//                    }
//                }
            KSVideoPlayerView(url: url, options: KSOptions())
        }
        .navigationTitle("KSPlayer")
        .onDisappear {
            url.stopAccessingSecurityScopedResource()
        }
    }
}
