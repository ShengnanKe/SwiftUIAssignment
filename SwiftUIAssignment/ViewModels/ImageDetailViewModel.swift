//
//  ImageDetailViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

@MainActor
class ImageDetailViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let photo: MediaPhoto
    private let httpClient = HttpClient()

    init(photo: MediaPhoto) {
        self.photo = photo
        loadImage()
    }

    func loadImage() {
        guard let url = URL(string: photo.src.large) else {
            errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil

        let request = URLRequestBuilder(url: url)

        httpClient.fetchData(request: request) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    if let uiImage = UIImage(data: data) {
                        self.image = uiImage
                    } else {
                        self.errorMessage = "Failed to load image"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct URLRequestBuilder: RequestBuilder {
    let url: URL

    var baseUrl: String { "" }
    var path: String? { nil }
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var queryParam: [String: String]? { nil }
    var bodyParam: [String: Any]? { nil }

    func buildRequest() throws -> URLRequest {
        return URLRequest(url: url)
    }
}
