//
//  VideoDetailViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI
import AVKit

@MainActor
class VideoDetailViewModel: ObservableObject {
    @Published var videoFileURL: URL?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isBookmarked: Bool = false

    let video: MediaVideo
    private let httpClient = HttpClient()
    private let dbManager = DBManager.shared
    private let fileManager = FAFileManager.shared

    init(video: MediaVideo) {
        self.video = video
        checkIfBookmarked()
        loadVideo()
    }

    private func checkIfBookmarked() {
        // Logic to check if the video is bookmarked
        let bookmarks = dbManager.fetchData(entity: Videos.self)
        isBookmarked = bookmarks.contains { $0.videoFilePath == video.videoFiles.first?.link }
    }

    func loadVideo() {
        guard let url = URL(string: video.videoFiles.first?.link ?? "") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        let request = SimpleRequest(url: url)
        httpClient.fetchData(request: request) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    let tempURL = FAFileManager.shared.tempDirectoryPath().appendingPathComponent(url.lastPathComponent)
                    do {
                        try data.write(to: tempURL)
                        self.videoFileURL = tempURL
                    } catch {
                        self.errorMessage = error.localizedDescription
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func bookmarkVideo() {
        if isBookmarked {
            if let videoEntity = dbManager.fetchData(entity: Videos.self).first(where: { $0.videoFilePath == video.videoFiles.first?.link }) {
                dbManager.deleteVideo(videoPath: videoEntity)
            }
        } else {
            dbManager.addVideoData(userName: video.user.name, videoPath: video.videoFiles.first?.link ?? "")
        }
        isBookmarked.toggle()
    }
}
