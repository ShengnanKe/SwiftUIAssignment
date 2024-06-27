//
//  VideoSearchResultsViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

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

    func searchVideos(page: Int = 1) async {
        guard !query.isEmpty, !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let request = VideoSearchRequest(query: query, page: page)
            let response: VideoDataModel = try await httpClient.fetch(requestBuilder: request)
            isLoading = false
            if page == 1 {
                self.videos = response.videos
            } else {
                self.videos.append(contentsOf: response.videos)
            }
            self.currentPage = page
            self.nextPage = response.nextPage
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func loadMoreVideos() async {
        if let nextPage = nextPage, !isLoading {
            await searchVideos(page: currentPage + 1)
        }
    }
}
