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

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data, let uiImage = UIImage(data: data) else {
                    self.errorMessage = "Failed to load image"
                    return
                }
                
                self.image = uiImage
            }
        }
        
        task.resume()
    }
}
