//
//  ImageSearchViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/19/24.
//

import SwiftUI

class ImageSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var images: [MediaPhoto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let httpClient = HttpClient()

    func searchImages() {
        guard !searchQuery.isEmpty else { return }
        
        let request = ImageSearchRequest(query: searchQuery)
        isLoading = true
        errorMessage = nil

        httpClient.fetch(request: request) { (result: Result<ImageDataModel, AppError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.images = response.photos
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
