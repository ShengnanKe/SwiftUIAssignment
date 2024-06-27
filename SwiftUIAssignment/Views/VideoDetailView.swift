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
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let videoURL = viewModel.videoFileURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text(viewModel.errorMessage ?? "No video available")
                    .padding()
            }
            
            Text("\(viewModel.video.user.name)")
                .font(.title2)
                .padding()
            
            Button(action: {
                Task{
                    await viewModel.bookmarkVideo()
                }
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
