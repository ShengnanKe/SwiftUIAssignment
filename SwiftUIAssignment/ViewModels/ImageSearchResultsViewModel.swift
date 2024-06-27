//
//  ImageSearchResultsViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

class ImageSearchResultsViewModel: ObservableObject {
    @Published var images: [MediaPhoto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    
    private let httpClient = HttpClient()
    private var currentPage = 1
    private var canLoadMorePages = true
  

    func searchImages(page: Int = 1) async {
        guard !searchQuery.isEmpty, !isLoading else { return }

        isLoading = true
        errorMessage = nil

        let request = ImageSearchRequest(query: searchQuery, page: page)

        do {
            let response: ImageDataModel = try await httpClient.fetch(requestBuilder: request)
            if page == 1 {
                self.images = response.photos
            } else {
                self.images.append(contentsOf: response.photos)
            }
            self.currentPage = page
            self.canLoadMorePages = response.photos.count == 20
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    func loadMoreImages() async {
        if canLoadMorePages {
            await searchImages(page: currentPage + 1)
        }
    }
}
