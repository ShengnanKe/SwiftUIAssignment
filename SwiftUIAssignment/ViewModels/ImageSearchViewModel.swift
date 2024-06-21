//
//  ImageSearchViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/19/24.
//

import SwiftUI

@MainActor
class ImageSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var images: [MediaPhoto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let httpClient = HttpClient()
    private var currentPage = 1
    private var canLoadMorePages = true

    func searchImages(query: String, page: Int = 1) {
        guard !query.isEmpty, !isLoading else { return }

        isLoading = true
        errorMessage = nil

        let request = ImageSearchRequest(query: query, page: page)

        httpClient.fetch(request: request) { (result: Result<ImageDataModel, AppError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if page == 1 {
                        self.images = response.photos
                    } else {
                        self.images.append(contentsOf: response.photos)
                    }
                    self.currentPage = page
                    self.canLoadMorePages = response.photos.count == 20 // Assuming 20 items per page
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadMoreImages(query: String) {
        if canLoadMorePages {
            searchImages(query: query, page: currentPage + 1)
        }
    }
}
