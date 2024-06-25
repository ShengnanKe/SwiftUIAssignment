//
//  ImageSearchResultsViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

@MainActor
class ImageSearchResultsViewModel: ObservableObject {
    @Published var images: [MediaPhoto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let httpClient = HttpClient()
    private var currentPage = 1
    private var canLoadMorePages = true
    var query: String

    init(query: String) {
        self.query = query
    }

    func searchImages(query: String, page: Int = 1) async {
        guard !query.isEmpty, !isLoading else { return }

        isLoading = true
        errorMessage = nil

        let request = ImageSearchRequest(query: query, page: page)

        do {
            let response: ImageDataModel = try await httpClient.fetch(request: request)
            if page == 1 {
                self.images = response.photos
            } else {
                self.images.append(contentsOf: response.photos)
            }
            self.currentPage = page
            self.canLoadMorePages = response.photos.count == 20 // Assuming 20 items per page
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    func loadMoreImages() async {
        if canLoadMorePages {
            await searchImages(query: query, page: currentPage + 1)
        }
    }
}
