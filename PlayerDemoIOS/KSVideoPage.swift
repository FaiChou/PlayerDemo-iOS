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
    var body: some View {
        VStack {
            KSVideoPlayerView(url: url, options: KSOptions())
        }
        .navigationTitle("KSPlayer")
        .onDisappear {
            url.stopAccessingSecurityScopedResource()
        }
    }
}
