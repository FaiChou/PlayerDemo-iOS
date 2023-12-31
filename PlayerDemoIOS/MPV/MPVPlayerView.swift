//
//  MPVPlayerView.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/8/15.
//

import Foundation
import SwiftUI

struct MPVPlayerView: UIViewControllerRepresentable {
    let playUrl : URL?
    let delegate: MPVDelegate
    func makeUIViewController(context: Context) -> some UIViewController {
        let mpv =  MPVViewController()
        mpv.playUrl = playUrl
        delegate.mpvViewController = mpv
        return mpv
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
