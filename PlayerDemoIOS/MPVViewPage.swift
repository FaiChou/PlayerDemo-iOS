//
//  MPVViewPage.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/8/15.
//

import SwiftUI

struct MPVViewPage: View {
    let url: URL
    @StateObject private var delegate = MPVDelegate()
    @State private var isPlay = true
    var body: some View {
        VStack {
            MPVPlayerView(playUrl: url, delegate: delegate)
            Button {
                if isPlay {
                    delegate.play()
                } else {
                    delegate.pause()
                }
            } label: {
                if isPlay {
                    Image(systemName: "pause.fill")
                } else {
                    Image(systemName: "play.fill")
                }
            }
            .padding()
            Button("List Infomations") {
                delegate.listInfos()
            }
        }
        .navigationTitle("MPV")
        .onDisappear {
            delegate.stop()
            url.stopAccessingSecurityScopedResource()
        }
    }
}

