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

    func searchImages(query: String) {
        guard !query.isEmpty else { return }
        
        let request = ImageSearchRequest(query: query)
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
