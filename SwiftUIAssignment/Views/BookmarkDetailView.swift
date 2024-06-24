//
//  BookmarkDetailView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/23/24.
//

import CoreData
import SwiftUI
import AVKit

struct BookmarkDetailView: View {
    let bookmark: NSManagedObject

    var body: some View {
        VStack {
            if let imagePath = bookmark as? Images, let path = imagePath.imageFilePath, let image = UIImage(contentsOfFile: path) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else if let videoPath = bookmark as? Videos, let path = videoPath.videoFilePath, let url = URL(string: path) {
                VideoPlayer(player: AVPlayer(url: url))
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text("No media available")
                    .padding()
            }
        }
    }
}
