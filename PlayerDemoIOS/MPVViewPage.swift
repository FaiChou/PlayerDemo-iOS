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
    @State private var progress = 0.5
    @State private var showAlert = false
    var body: some View {
        VStack {
            MPVPlayerView(playUrl: url, delegate: delegate)
            VStack {
                VStack {
                    ProgressView(value: delegate.currentTime/delegate.totalTime)
                    HStack {
                        Text(timeString(from: delegate.currentTime))
                        Spacer()
                        Text(timeString(from: delegate.totalTime))
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 5)
                }
                HStack {
                    Button {
                        if delegate.isPlaying {
                            delegate.pause()
                        } else {
                            delegate.play()
                        }
                    } label: {
                        if delegate.isPlaying {
                            Image(systemName: "pause.fill")
                                .resizable()
                        } else {
                            Image(systemName: "play.fill")
                                .resizable()
                        }
                    }
                    .frame(width: 23, height: 23)
                    .padding()
                    Spacer()
                    Button {
                        delegate.listInfos()
                        showAlert = true
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                    }
                    .frame(width: 28, height: 28)
                }
                .padding()
            }
            .alert("影片信息", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(delegate.displayInfos)
            }
        }
        .onDisappear {
            url.stopAccessingSecurityScopedResource()
        }
    }
    private func timeString(from seconds: Float) -> String {
        let totalSeconds = Int(seconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

