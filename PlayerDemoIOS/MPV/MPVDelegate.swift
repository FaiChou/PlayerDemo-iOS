//
//  MPVViewControllerModel.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/8/17.
//

import Foundation
import SwiftUI
import CoreMedia

class MPVDelegate: ObservableObject {
    var mpvViewController: MPVViewController? = nil
    @Published var currentTime: Float = 0.0
    @Published var totalTime: Float = 1.0
    @Published var displayInfos: String = ""
    @Published var isPlaying = true
    var timer: Timer?
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let c = self?.mpvViewController else { return }
            self?.currentTime = Float(c.currentTime.seconds)
            self?.totalTime = Float(c.duration.seconds)
        })
    }
    deinit {
        timer?.invalidate()
    }
    func play() {
        mpvViewController?.play()
        isPlaying = true
    }
    func pause() {
        mpvViewController?.pause()
        isPlaying = false
    }
//    func togglePlay() {
//        mpvViewController?.togglePlay()
//    }
    func stop() {
        mpvViewController?.stop()
        isPlaying = false
    }
    func listInfos() {
        guard let mpvController = mpvViewController else {
            displayInfos = "获取失败"
            print("Need init first")
            return
        }
        print("=== MPV list infos start ===")
        print("currentTime: \(mpvController.currentTime)")
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
        displayInfos = """
                       videoFormat: \(mpvController.videoFormat)
                       videoCodec: \(mpvController.videoCodec)
                       currentVo: \(mpvController.currentVo)
                       width: \(mpvController.width)
                       height: \(mpvController.height)
                       videoBitrate: \(mpvController.videoBitrate)
                       audioFormat: \(mpvController.audioFormat)
                       currentAo: \(mpvController.currentAo)
                       audioChannels: \(mpvController.audioChannels)
                       audioSampleRate: \(mpvController.audioSampleRate)
                       """
    }
}
