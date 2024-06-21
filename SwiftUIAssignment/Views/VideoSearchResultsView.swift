//
//  VideoSearchResultsView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct VideoSearchResultsView: View {
    @ObservedObject var viewModel: VideoSearchResultsViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.videos.isEmpty {
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
                    ForEach(viewModel.videos.indices, id: \.self) { index in
                        let video = viewModel.videos[index]
                        NavigationLink(destination: VideoDetailView(viewModel: VideoDetailViewModel(video: video))) {
                            AsyncImage(url: URL(string: video.image)!)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onAppear {
                                    if index == viewModel.videos.count - 1 {
                                        viewModel.loadMoreVideos()
                                    }
                                }
                        }
                    }
                }
                .padding()
            }

            if viewModel.isLoading && !viewModel.videos.isEmpty {
                ProgressView()
                    .padding()
            }
        }
        .navigationTitle("Search Results")
        .onAppear {
            viewModel.searchVideos()
        }
    }
}

struct VideoSearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        VideoSearchResultsView(viewModel: VideoSearchResultsViewModel(query: "nature"))
    }
}
