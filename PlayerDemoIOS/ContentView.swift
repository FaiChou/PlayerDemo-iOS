//
//  ContentView.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/6/27.
//

import SwiftUI
import KSPlayer

struct ContentView: View {
    @State private var showFileImporter = false
//    let testMkvFilePath = Bundle.main.path(forResource: "test", ofType: "mkv")!
//    let options = KSOptions()
    var body: some View {
        VStack {
            Button {
               showFileImporter = true
            } label: {
               Label("Choose a video", systemImage: "video")
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
                       // access the directory URL
                       // (read templates in the directory, make a bookmark, etc.)
                       handlePickedVideo(file)
                       // release access
                       file.stopAccessingSecurityScopedResource()
                   }
               case .failure(let error):
                   // handle error
                   print(error)
               }
           }
        }
    }
    func handlePickedVideo(_ url: URL) {
        print(url)
    }
}
