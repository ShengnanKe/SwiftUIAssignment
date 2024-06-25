//
//  ImageDetailView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageDetailView: View {
    @StateObject private var viewModel: ImageDetailViewModel
    
    init(photo: MediaPhoto) {
        _viewModel = StateObject(wrappedValue: ImageDetailViewModel(photo: photo))
    }
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
            
            Text(viewModel.photo.photographer)
                .font(.title2)
                .padding()
            
            Text(viewModel.photo.alt)
                .font(.title3)
                .padding()
            
            Button(action: {
                viewModel.bookmarkImage()
            }) {
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
            }
            .padding()
        }
        .navigationTitle("Image Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadImage()
            }
        }
    }
}
