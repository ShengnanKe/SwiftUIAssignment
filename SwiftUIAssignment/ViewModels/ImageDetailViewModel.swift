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
    private let fileManager = FAFileManager.shared
    private let cacheManager = FACacheManager()

    init(photo: MediaPhoto) {
        self.photo = photo
        checkIfBookmarked()
        loadImage()
    }

    private func checkIfBookmarked() {
        let bookmarks = dbManager.fetchData(entity: Images.self)
        isBookmarked = bookmarks.contains { $0.imageFilePath == photo.src.original }
    }

    func loadImage() {
        guard let url = URL(string: photo.src.large) else {
            errorMessage = "Invalid URL"
            return
        }

        // Check if image is cached
        if let cachedImage = cacheManager.getImage(forKey: url.absoluteString) {
            image = cachedImage
            return
        }

        // Download the image if not cached
        isLoading = true
        errorMessage = nil

        httpClient.download(request: SimpleRequest(url: url)) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let tempURL):
                    let fileName = url.lastPathComponent
                    guard let imagesDirectory = self.fileManager.getDirectory(for: "Images") else {
                        self.errorMessage = "Failed to access images directory"
                        return
                    }
                    let destinationURL = imagesDirectory.appendingPathComponent(fileName)
                    
                    do {
                        // Ensure the directory exists
                        let directory = destinationURL.deletingLastPathComponent()
                        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                        
                        try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                        if let imageData = try? Data(contentsOf: destinationURL), let uiImage = UIImage(data: imageData) {
                            self.image = uiImage
                            self.cacheManager.saveImage(uiImage, forKey: url.absoluteString)
                        } else {
                            self.errorMessage = "Failed to load image from file"
                        }
                    } catch {
                        self.errorMessage = "Failed to save downloaded file: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func bookmarkImage() {
        if isBookmarked {
            if let imageEntity = dbManager.fetchData(entity: Images.self).first(where: { $0.imageFilePath == photo.src.original }) {
                dbManager.deleteImage(imagePath: imageEntity)
            }
        } else {
            let imageLink = photo.src.original
            guard let url = URL(string:imageLink) else { return }
            let fileName = url.lastPathComponent ?? UUID().uuidString + ".jpg"
            guard let imagesDirectory = fileManager.getDirectory(for: "Images") else { return }
            let destinationURL = imagesDirectory.appendingPathComponent(fileName)
            dbManager.addImageData(title: photo.alt, path: destinationURL.path)
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
