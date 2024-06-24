//
//  VideoDetailView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    @ObservedObject var viewModel: VideoDetailViewModel

    var body: some View {
        VStack {
            if let videoURL = viewModel.videoFileURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text("No video available")
                    .padding()
            }

            Text("Video by \(viewModel.video.user.name)")
                .font(.title2)
                .padding()

            Button(action: {
                viewModel.bookmarkVideo()
            }) {
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    .padding()
            }

            Spacer()
        }
        .navigationTitle("Video Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
