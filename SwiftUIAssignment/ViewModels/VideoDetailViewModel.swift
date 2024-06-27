//
//  VideoDetailViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI
import AVKit
import CoreData

class VideoDetailViewModel: ObservableObject {
    @Published var videoFileURL: URL?
    @Published var errorMessage: String?
    @Published var isBookmarked: Bool = false
    
    let video: MediaVideo
    private let httpClient = HttpClient()
    private let dbManager = DBManager.shared
    private let fileManager = FAFileManager.shared
    
    init(video: MediaVideo) {
        self.video = video
    }
    
    private func handleDownloadedVideo(tempURL: URL, originalURL: URL) async {
        let fileName = originalURL.lastPathComponent
        guard let videosDirectory = fileManager.getDirectory(for: "Videos") else {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to access videos directory"
            }
            return
        }
        
        do {
            try FileManager.default.createDirectory(at: videosDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to create videos directory: \(error.localizedDescription)"
            }
            return
        }
        
        let destinationURL = videosDirectory.appendingPathComponent(fileName)
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.moveItem(at: tempURL, to: destinationURL)
//            DispatchQueue.main.async {
//                self.videoFileURL = destinationURL
//            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to save downloaded file: \(error.localizedDescription)"
            }
        }
    }
    
    func bookmarkVideo(context: NSManagedObjectContext) async {
        isBookmarked = true
        dbManager.setContext(context)
        
        guard let videoLink = video.videoFiles.first?.link, let url = URL(string: videoLink) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid video link"
            }
            return
        }
        
        let requestBuilder = SimpleRequest(url: url)
        
        do {
            let tempURL = try await httpClient.download(requestBuilder: requestBuilder)
            await handleDownloadedVideo(tempURL: tempURL, originalURL: url)
            
            let fileName = url.lastPathComponent
            guard let videosDirectory = fileManager.getDirectory(for: "Videos") else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to access videos directory"
                }
                return
            }
            let destinationURL = videosDirectory.appendingPathComponent(fileName)
            print(destinationURL)
            self.dbManager.addVideoData(userName: self.video.user.name, fileName: fileName)

//            DispatchQueue.main.async {
//                self.isBookmarked = true
//            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to download video: \(error.localizedDescription)"
            }
        }
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
