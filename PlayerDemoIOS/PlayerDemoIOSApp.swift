//
//  PlayerDemoIOSApp.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/6/27.
//

import SwiftUI
import KSPlayer

@main
struct PlayerDemoIOSApp: App {
    init() {
        #if DEBUG
        KSOptions.logLevel = .debug
        #endif
        KSOptions.firstPlayerType = KSMEPlayer.self
        KSOptions.secondPlayerType = KSMEPlayer.self
        KSOptions.isSecondOpen = true
        KSOptions.isAccurateSeek = true
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
