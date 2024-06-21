//
//  VideoDetailViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

class VideoDetailViewModel: ObservableObject {
    @Published var video: MediaVideo
    @Published var videoFileURL: URL?

    init(video: MediaVideo) {
        self.video = video
        setupVideoFileURL()
    }

    private func setupVideoFileURL() {
        // Assuming you want the highest quality video file
        if let videoFile = video.videoFiles.first(where: { $0.quality == "hd" }) {
            videoFileURL = URL(string: videoFile.link)
        } else {
            videoFileURL = URL(string: video.videoFiles.first?.link ?? "")
        }
    }
}
