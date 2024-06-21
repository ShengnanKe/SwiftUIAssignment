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
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        let photo = viewModel.images[index]
                        NavigationLink(destination: ImageDetailView(viewModel: ImageDetailViewModel(photo: photo))) {
                            AsyncImage(url: URL(string: photo.src.small)!)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onAppear {
                                    if index == viewModel.images.count - 1 {
                                        viewModel.loadMoreImages()
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
            viewModel.searchImages()
        }
    }
}

struct ImageSearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSearchResultsView(viewModel: ImageSearchResultsViewModel(query: "nature"))
    }
}
