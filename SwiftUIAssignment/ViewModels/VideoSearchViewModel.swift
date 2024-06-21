//
//  VideoSearchViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

@MainActor
class VideoSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var videos: [MediaVideo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let httpClient = HttpClient()
    private var currentPage = 1
    private var canLoadMorePages = true

    func searchVideos(query: String, page: Int = 1) {
        guard !query.isEmpty, !isLoading else { return }

        isLoading = true
        errorMessage = nil

        let request = VideoSearchRequest(query: query, page: page)

        httpClient.fetch(request: request) { (result: Result<VideoDataModel, AppError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if page == 1 {
                        self.videos = response.videos
                    } else {
                        self.videos.append(contentsOf: response.videos)
                    }
                    self.currentPage = page
                    self.canLoadMorePages = response.videos.count == 20 
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadMoreVideos(query: String) {
        if canLoadMorePages {
            searchVideos(query: query, page: currentPage + 1)
        }
    }
}
