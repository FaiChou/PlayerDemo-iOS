//
//  MPVViewPage.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/8/15.
//

import SwiftUI

struct MPVViewPage: View {
    let url: URL
    var body: some View {
        VStack {
            MPVPlayerView(playUrl: url)
        }
        .navigationTitle("MPV")
        .ignoresSafeArea()
        .onDisappear {
            url.stopAccessingSecurityScopedResource()
        }
    }
}

