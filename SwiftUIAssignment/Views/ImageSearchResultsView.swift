//
//  ImageSearchResultsView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchResultsView: View {
    @StateObject private var viewModel: ImageSearchResultsViewModel

    init(searchQuery: String) {
        _viewModel = StateObject(wrappedValue: ImageSearchResultsViewModel(query: searchQuery))
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(viewModel.images, id: \.id) { photo in
                    NavigationLink(destination: ImageDetailView(photo: photo)) {
                        AsyncImageLoader(url: URL(string: photo.src.small))
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onAppear {
                                if photo == viewModel.images.last {
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
                await viewModel.searchImages()
            }
        }
    }
}


