//
//  ImageSearchResultsView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchResultsView: View {
    @ObservedObject var viewModel: ImageSearchResultsViewModel

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(viewModel.images.indices, id: \.self) { index in
                    let photo = viewModel.images[index]
                    NavigationLink(destination: LazyView(ImageDetailView(photo: photo))) {
                        AsyncImage(url: URL(string: photo.src.small)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .failure:
                                Text("Failed to load image")
                                    .foregroundColor(.red)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .onAppear {
                            if index == viewModel.images.count - 1 {
                                Task {
                                    await viewModel.loadMoreImages()
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Search Results")
        .onAppear {
            Task {
                await viewModel.searchImages(query: "nature")
            }
        }
    }
}
