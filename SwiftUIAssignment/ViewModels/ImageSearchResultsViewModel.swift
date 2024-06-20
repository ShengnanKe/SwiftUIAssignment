//
//  ImageSearchResultsViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import Foundation
import SwiftUI

@MainActor
class ImageSearchResultsViewModel: ObservableObject {
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
                    self.images.append(contentsOf: response.photos)
                    self.currentPage += 1
                    self.canLoadMorePages = response.photos.count == 20
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadMoreImages(query: String) {
        if canLoadMorePages {
            searchImages(query: query, page: currentPage)
        }
    }
}
