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
    private let cacheManager = FACacheManager()

    init(video: MediaVideo) {
        self.video = video
        checkIfBookmarked()
        loadVideo()
    }

    private func checkIfBookmarked() {
        let bookmarks: [Videos] = dbManager.fetchData(entity: Videos.self)
        if let videoFileName = URL(string: video.videoFiles.first?.link ?? "")?.lastPathComponent {
            isBookmarked = bookmarks.contains { bookmark in
                bookmark.videoFileName == videoFileName
            }
        } else {
            isBookmarked = false
        }
    }

    func loadVideo() {
        guard let videoLink = video.videoFiles.first?.link, let url = URL(string: videoLink) else {
            errorMessage = "Invalid URL"
            return
        }

        // Check if video is cached
        if let cachedURL = cacheManager.getVideoURL(forKey: videoLink) {
            videoFileURL = cachedURL
            return
        }

        // Download the video if not cached
        isLoading = true
        errorMessage = nil

        httpClient.download(request: SimpleRequest(url: url)) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let tempURL):
                    let fileName = url.lastPathComponent
                    guard let videosDirectory = self.fileManager.getDirectory(for: "Videos") else {
                        self.errorMessage = "Failed to access videos directory"
                        return
                    }
                    let destinationURL = videosDirectory.appendingPathComponent(fileName)
                    
                    do {
                        try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                        self.videoFileURL = destinationURL
                        self.cacheManager.saveVideoURL(destinationURL, forKey: videoLink)
                    } catch {
                        self.errorMessage = "Failed to save downloaded file: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func bookmarkVideo() {
        if isBookmarked {
            if let videoEntity = dbManager.fetchData(entity: Videos.self).first(where: { $0.videoFileName == URL(string: video.videoFiles.first?.link ?? "")?.lastPathComponent }) {
                dbManager.deleteVideo(videoEntity: videoEntity)
            }
        } else {
            guard let videoLink = video.videoFiles.first?.link else { return }
            let fileName = URL(string: videoLink)?.lastPathComponent ?? UUID().uuidString + ".mp4"
            guard let videosDirectory = fileManager.getDirectory(for: "Videos") else { return }
            let destinationURL = videosDirectory.appendingPathComponent(fileName)
            // Download video logic here if needed
            dbManager.addVideoData(userName: video.user.name, fileName: fileName)
        }
        isBookmarked.toggle()
    }

}

struct SimpleRequest: RequestBuilder {
    var baseUrl: String { "" }
    var path: String? { nil }
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var queryParam: [String: String]? { nil }
    var bodyParam: [String: Any]? { nil }

    let url: URL

    func buildRequest() throws -> URLRequest {
        return URLRequest(url: url)
    }
}
