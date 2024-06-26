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

    func searchVideos(page: Int = 1) async {
        guard !query.isEmpty, !isLoading else { return }

        isLoading = true
        errorMessage = nil

        let request: URLRequest
        do {
            request = try VideoSearchRequest(query: query, page: page).buildRequest()
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            return
        }

        do {
            let response: VideoDataModel = try await httpClient.fetch(request: request)
            self.isLoading = false
            if page == 1 {
                self.videos = response.videos
            } else {
                self.videos.append(contentsOf: response.videos)
            }
            self.currentPage = page
            self.nextPage = response.nextPage
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }

    func loadMoreVideos() async {
        if let nextPage = nextPage, !isLoading {
            await searchVideos(page: currentPage + 1)
        }
    }
}
