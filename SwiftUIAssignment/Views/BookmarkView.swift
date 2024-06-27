//
//  BookmarkView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

struct BookmarkView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel = BookmarkViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.bookmarkedImages, id: \.self) { image in
                    NavigationLink(destination: BookmarkDetailView(bookmark: .image(image))) {
                        Text(image.imageDescription ?? "")
                    }
                }
                ForEach(viewModel.bookmarkedVideos, id: \.self) { video in
                    NavigationLink(destination: BookmarkDetailView(bookmark: .video(video))) {
                        Text(video.videoFileName ?? "")
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .onAppear {
                viewModel.setup(context: viewContext)
                viewModel.fetchBookmarks()
          
            }
        }
    }
}
