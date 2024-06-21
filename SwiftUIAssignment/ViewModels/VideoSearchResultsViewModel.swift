//
//  VideoSearchResultsViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

@MainActor
class VideoSearchResultsViewModel: ObservableObject {
    @Published var videos: [MediaVideo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let httpClient = HttpClient()
    private var currentPage = 1
    private var nextPage: String?
    var query: String

    init(query: String) {
        self.query = query
    }

    func searchVideos(page: Int = 1) {
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
                    self.nextPage = response.nextPage
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadMoreVideos() {
        if let nextPage = nextPage, !isLoading {
            searchVideos(page: currentPage + 1)
        }
    }
}
