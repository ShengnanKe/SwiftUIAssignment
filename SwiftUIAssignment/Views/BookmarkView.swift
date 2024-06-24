//
//  BookmarkView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

struct BookmarkView: View {
    @StateObject private var viewModel = BookmarkViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.bookmarkedImages, id: \.self) { image in
                    NavigationLink(destination: BookmarkDetailView(bookmark: image)) {
                        Text(image.imageDescription ?? "")
                    }
                }
                ForEach(viewModel.bookmarkedVideos, id: \.self) { video in
                    NavigationLink(destination: BookmarkDetailView(bookmark: video)) {
                        Text(video.videoFileName ?? "")
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .onAppear {
                viewModel.fetchBookmarks()
            }
        }
    }
}
