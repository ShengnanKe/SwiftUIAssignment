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
    private let dbManager = DBManager.shared
    private let fileManager = FAFileManager.shared

    init(photo: MediaPhoto) {
        self.photo = photo
        checkIfBookmarked()
        Task {
            await loadImage()
        }
    }

    private func checkIfBookmarked() {
        let bookmarks = dbManager.fetchData(entity: Images.self)
        isBookmarked = bookmarks.contains { $0.imageFileName == photo.src.original }
    }

    func bookmarkImage() {
        if isBookmarked {
            if let imageEntity = dbManager.fetchData(entity: Images.self).first(where: { $0.imageFileName == photo.src.original }) {
                dbManager.deleteImage(imageEntity: imageEntity)
            }
        } else {
            Task {
                await saveImageToLocalStorage()
            }
        }
        isBookmarked.toggle()
    }

    private func saveImageToLocalStorage() async {
        let imageLink = photo.src.original
        guard let url = URL(string: imageLink) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let imagesDirectory = fileManager.getDirectory(for: "Images") else { return }
            let fileName = url.lastPathComponent
            let destinationURL = imagesDirectory.appendingPathComponent(fileName)
            try data.write(to: destinationURL)
            dbManager.addImageData(title: photo.alt, fileName: fileName)
        } catch {
            print("Failed to save image: \(error)")
        }
    }

    func loadImage() async {
        let imageLink = photo.src.large
        guard let url = URL(string: imageLink) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image = UIImage(data: data)
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
