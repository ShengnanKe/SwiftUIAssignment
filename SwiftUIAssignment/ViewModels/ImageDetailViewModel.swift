//
//  ImageDetailViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI
import CoreData

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
        //checkIfBookmarked()
        Task {
            await loadImage()
        }
    }
    
    //    private func checkIfBookmarked() {
    //        let bookmarks = dbManager.fetchData(entity: Images.self)
    //        isBookmarked = bookmarks.contains { $0.imageFileName == photo.src.original }
    //    }
    
    func bookmarkImage(context: NSManagedObjectContext) {
        dbManager.setContext(context)
        
        
        Task {
            await saveImageToLocalStorage(context: context)
        }
        
    }
    
    private func saveImageToLocalStorage(context: NSManagedObjectContext) async {
        let imageLink = photo.src.original
        guard let url = URL(string: imageLink) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let imagesDirectory = fileManager.getDirectory(for: "Images") else { return }
            let fileName = url.lastPathComponent
            let destinationURL = imagesDirectory.appendingPathComponent(fileName)
            try data.write(to: destinationURL)
            dbManager.context = context
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
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
