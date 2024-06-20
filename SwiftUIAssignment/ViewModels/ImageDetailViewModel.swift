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
//    private let bookmarkManager = BookmarkManager.shared

    init(photo: MediaPhoto) {
        self.photo = photo
//        checkIfBookmarked()
    }

    func loadImage() {
        guard let url = URL(string: photo.src.large) else {
            errorMessage = "Invalid URL"
            return
        }
        
        let request = RawDataRequest(url: url)
        isLoading = true
        errorMessage = nil

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
    
//    func saveBookmark() {
//        guard let imageData = image?.jpegData(compressionQuality: 1.0) else {
//            errorMessage = "Failed to get image data"
//            return
//        }
//        
//        let filePath = saveImageLocally(imageData: imageData, fileName: "\(photo.id).jpg")
//        
//        let bookmark = MediaBookmarkModel(name: photo.photographer, url: photo.url, filePath: filePath)
//        if bookmarkManager.addBookmark(bookmark: bookmark) {
//            isBookmarked = true
//        } else {
//            errorMessage = "Failed to save bookmark"
//        }
//    }
//
//    func checkIfBookmarked() {
//        let bookmarks = bookmarkManager.fetchBookmarks()
//        isBookmarked = bookmarks.contains { $0.url == photo.url }
//    }
//
//    func deleteBookmark() {
//        if bookmarkManager.deleteBookmark(filePath: "\(photo.id).jpg") {
//            isBookmarked = false
//        } else {
//            errorMessage = "Failed to delete bookmark"
//        }
//    }
//    
//    private func saveImageLocally(imageData: Data, fileName: String) -> String {
//        let fileManager = FileManager.default
//        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = urls[0]
//        let fileURL = documentsDirectory.appendingPathComponent(fileName)
//        
//        do {
//            try imageData.write(to: fileURL)
//            return fileURL.path
//        } catch {
//            print("Error saving image locally: \(error)")
//            return ""
//        }
//    }
}
