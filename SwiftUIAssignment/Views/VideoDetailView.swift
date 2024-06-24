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

struct VideoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let video = MediaVideo(
            id: 1,
            width: 1920,
            height: 1080,
            url: "https://example.com",
            image: "https://via.placeholder.com/500",
            fullRes: nil,
            tags: [],
            duration: 120,
            user: User(id: 1, name: "John Doe", url: "https://example.com"),
            videoFiles: [
                VideoFile(id: 1, quality: "hd", fileType: "mp4", width: 1920, height: 1080, fps: 30.0, link: "https://www.example.com/video.mp4")
            ],
            videoPictures: []
        )
        VideoDetailView(viewModel: VideoDetailViewModel(video: video))
    }
}
