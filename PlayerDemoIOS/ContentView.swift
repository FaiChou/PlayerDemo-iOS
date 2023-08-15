//
//  ContentView.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/6/27.
//

import SwiftUI
import KSPlayer

enum PlayerType: String, CaseIterable, Identifiable {
    case ksplayer, mpv
    var id: Self { self }
}

struct ContentView: View {
    @State private var showFileImporter = false
    @State private var urls: [URL] = []
    @State private var selectedPlayer: PlayerType = .ksplayer
    var body: some View {
        NavigationStack(path: $urls) {
            Form {
                Picker("Player type", selection: $selectedPlayer) {
                    Text("KSPlayer").tag(PlayerType.ksplayer)
                    Text("mpv").tag(PlayerType.mpv)
                }
                Button("Choose a video") {
                    showFileImporter = true
                }
                .fileImporter(
                    isPresented: $showFileImporter,
                    allowedContentTypes: [.item],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let files):
                        files.forEach { file in
                            // gain access to the directory
                            let gotAccess = file.startAccessingSecurityScopedResource()
                            if !gotAccess { return }
                            urls = [file]
                        }
                    case .failure(let error):
                        // handle error
                        print(error)
                    }
                }
            }
            .navigationTitle("PlayerDemo")
            .navigationDestination(for: URL.self) { url in
                KSVideoPage(url: url)
            }
        }
    }
}
