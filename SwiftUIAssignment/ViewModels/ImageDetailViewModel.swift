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
    @Published var isBookmarked: Bool = false

    let photo: MediaPhoto
    private let httpClient = HttpClient()
    private let dbManager = DBManager.shared

    init(photo: MediaPhoto) {
        self.photo = photo
        checkIfBookmarked()
        loadImage()
    }

    private func checkIfBookmarked() {
        // Logic to check if the image is bookmarked
        let bookmarks = dbManager.fetchData(entity: Images.self)
        isBookmarked = bookmarks.contains { $0.imageFilePath == photo.src.large }
    }

    func loadImage() {
        guard let url = URL(string: photo.src.large) else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        let request = SimpleRequest(url: url)
        httpClient.fetchData(request: request) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.image = UIImage(data: data)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func bookmarkImage() {
        if isBookmarked {
            if let imageEntity = dbManager.fetchData(entity: Images.self).first(where: { $0.imageFilePath == photo.src.large }) {
                dbManager.deleteImage(imagePath: imageEntity)
            }
        } else {
            dbManager.addImageData(title: photo.alt, path: photo.src.large)
        }
        isBookmarked.toggle()
    }
}


struct SimpleRequest: RequestBuilder {
    var baseUrl: String { "" }
    var path: String? { nil }
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var queryParam: [String: String]? { nil }
    var bodyParam: [String: Any]? { nil }

    let url: URL

    func buildRequest() throws -> URLRequest {
        return URLRequest(url: url)
    }
}
