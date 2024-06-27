//
//  VideoDetailView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: VideoDetailViewModel
    
    var body: some View {
        VStack {
            if let videoLink = viewModel.video.videoFiles.first?.link, let videoURL = URL(string: videoLink) {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text(viewModel.errorMessage ?? "No video available")
                    .padding()
            }

            Text("Video by \(viewModel.video.user.name)")
                .font(.title2)
                .padding()

            Button(action: {
                Task {
                    await viewModel.bookmarkVideo(context: viewContext)
                }
            }) {
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    .padding()
            }

            Spacer()
        }
        .navigationTitle("Video Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
        }
    }
}
