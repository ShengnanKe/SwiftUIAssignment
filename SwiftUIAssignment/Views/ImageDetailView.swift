//
//  ImageDetailView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageDetailView: View {
    @StateObject var viewModel: ImageDetailViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }

            Text(viewModel.photo.photographer)
                .font(.title)
                .padding()

            Text(viewModel.photo.alt)
                .font(.body)
                .padding()
            
            Button(action: {
                viewModel.bookmarkImage()
            }) {
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    .padding()
            }

            Spacer()
        }
        .navigationTitle("Image Detail")
        .onAppear {
            viewModel.loadImage()
        }
    }
}

