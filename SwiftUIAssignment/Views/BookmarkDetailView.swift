//
//  BookmarkDetailView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/23/24.
//

import CoreData

enum Bookmark {
    case image(Images)
    case video(Videos)
}

import SwiftUI
import AVKit

struct BookmarkDetailView: View {
    let bookmark: Bookmark

    var body: some View {
        VStack {
            switch bookmark {
            case .image(let image):
                if let fileName = image.imageFileName,
                   let imagesDirectory = FAFileManager.shared.getDirectory(for: "Images") {
                    let fullPath = imagesDirectory.appendingPathComponent(fileName).path
                    if let image = UIImage(contentsOfFile: fullPath) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    } else {
                        Text("No media available")
                            .padding()
                    }
                }
            case .video(let video):
                if let fileName = video.videoFileName,
                   let videosDirectory = FAFileManager.shared.getDirectory(for: "Videos") {
                    let fullPath = videosDirectory.appendingPathComponent(fileName)
                    VideoPlayer(player: AVPlayer(url: fullPath))
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("No media available")
                        .padding()
                }
            }
        }
    }
}
