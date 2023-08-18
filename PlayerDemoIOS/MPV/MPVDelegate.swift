//
//  MPVViewControllerModel.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/8/17.
//

import Foundation
import SwiftUI

class MPVDelegate: ObservableObject {
    var mpvViewController: MPVViewController? = nil
    func play() {
        mpvViewController?.play()
    }
    func pause() {
        mpvViewController?.pause()
    }
    func togglePlay() {
        mpvViewController?.togglePlay()
    }
    func stop() {
        mpvViewController?.stop()
    }
    func listInfos() {
        guard let mpvController = mpvViewController else {
            print("Need init first")
            return
        }
        print("=== MPV list infos start ===")
        print("autoPlay: \(mpvController.autoPlay)")
        print("playUrl: \(String(describing: mpvController.playUrl))")
        print("videoFormat: \(mpvController.videoFormat)")
        print("videoCodec: \(mpvController.videoCodec)")
        print("currentVo: \(mpvController.currentVo)")
        print("width: \(mpvController.width)")
        print("height: \(mpvController.height)")
        print("videoBitrate: \(mpvController.videoBitrate)")
        print("audioFormat: \(mpvController.audioFormat)")
        print("audioCodec: \(mpvController.audioCodec)")
        print("currentAo: \(mpvController.currentAo)")
        print("audioChannels: \(mpvController.audioChannels)")
        print("audioSampleRate: \(mpvController.audioSampleRate)")
        print("duration: \(mpvController.duration)")
        print("=== MPV list infos end   ===")
    }
}
