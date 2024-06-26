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
        Task {
            await loadVideo()
        }
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

    func loadVideo() async {
        guard let videoLink = video.videoFiles.first?.link, let url = URL(string: videoLink) else {
            errorMessage = "Invalid URL"
            return
        }

        // Set loading state
        isLoading = true
        errorMessage = nil

        do {
            let requestBuilder = SimpleRequest(url: url)
            let tempURL = try await httpClient.download(requestBuilder: requestBuilder)
            await handleDownloadedVideo(tempURL: tempURL, originalURL: url)
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    private func handleDownloadedVideo(tempURL: URL, originalURL: URL) async {
        let fileName = originalURL.lastPathComponent
        guard let videosDirectory = fileManager.getDirectory(for: "Videos") else {
            errorMessage = "Failed to access videos directory"
            return
        }

        // Ensure the directory exists
        do {
            try FileManager.default.createDirectory(at: videosDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            errorMessage = "Failed to create videos directory: \(error.localizedDescription)"
            return
        }

        let destinationURL = videosDirectory.appendingPathComponent(fileName)

        do {
            // Check if the file already exists and handle accordingly
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.moveItem(at: tempURL, to: destinationURL)
            videoFileURL = destinationURL
        } catch {
            errorMessage = "Failed to save downloaded file: \(error.localizedDescription)"
        }

        isLoading = false
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
