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
    private var nextPage: String?
    var query: String

    init(query: String) {
        self.query = query
    }

    func searchImages(page: Int = 1) {
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
                    self.nextPage = response.nextPage
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadMoreImages() {
        if let nextPage = nextPage, !isLoading {
            searchImages(page: currentPage + 1)
        }
    }
}
