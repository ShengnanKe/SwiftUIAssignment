//
//  ImageSearchResultsListView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchResultsListView: View {
    @StateObject var viewModel = ImageSearchResultsViewModel()
    var query: String

    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.images.isEmpty {
                ProgressView()
                    .padding()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(viewModel.images, id: \.id) { photo in
                        NavigationLink(destination: ImageDetailView(viewModel: ImageDetailViewModel(photo: photo))) {
                            AsyncImage(url: URL(string: photo.src.small)!)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onAppear {
                                    if viewModel.images.last == photo {
                                        viewModel.loadMoreImages(query: query)
                                    }
                                }
                        }
                    }
                }
                .padding()
            }

            if viewModel.isLoading && !viewModel.images.isEmpty {
                ProgressView()
                    .padding()
            }
        }
        .navigationTitle("Search Results")
        .onAppear {
            viewModel.searchImages(query: query)
        }
    }
}

struct ImageSearchResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ImageSearchResultsViewModel()
        viewModel.images = [
            MediaPhoto(id: 1, width: 100, height: 100, url: "https://via.placeholder.com/100", photographer: "Photographer Name", photographerUrl: "https://via.placeholder.com", photographerId: 123, avgColor: "#CCCCCC", src: PhotoSrc(original: "https://via.placeholder.com/500", small: "https://via.placeholder.com/100", large: "https://via.placeholder.com/500"), liked: false, alt: "Sample Image")
        ]
        return ImageSearchResultsListView(query: "nature")
    }
}
