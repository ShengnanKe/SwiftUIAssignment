//
//  ImageSearchResultsView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchResultsView: View {
    @ObservedObject var viewModel: ImageSearchResultsViewModel
//    var query: String

    var body: some View {
        ScrollView {
            LazyGrid(items: viewModel.images) { photo in
                NavigationLink(destination: LazyView(ImageDetailView(viewModel: ImageDetailViewModel(photo: photo)))) {
                    AsyncImageLoader(url: URL(string: photo.src.small))
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
        .navigationTitle("Search Results")
        .onAppear {
            Task {
                await viewModel.searchImages()
            }
        }
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
