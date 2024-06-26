//
//  ImageSearchResultsView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchResultsView: View {
    @ObservedObject var viewModel: ImageSearchResultsViewModel
    var query: String

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(viewModel.images, id: \.id) { photo in
                    NavigationLink(destination: LazyView(ImageDetailView(viewModel: ImageDetailViewModel(photo: photo)))) {
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
                await viewModel.searchImages(query: query)
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
