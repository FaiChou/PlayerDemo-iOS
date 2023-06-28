//
//  ContentView.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/6/27.
//

import SwiftUI
import AVKit

let url = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"
let url2 = "https://bj29-hz.cn-hangzhou.data.alicloudccp.com"

struct ContentView: View {
    let player = AVPlayer(url: URL(string: url2)!)
    var body: some View {
        VideoPlayer(player: player)
        HStack {
            Button("Play") {
                player.play()
            }
            Button("Pause") {
                player.pause()
            }
        }
    }
}
