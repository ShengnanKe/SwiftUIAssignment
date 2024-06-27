//
//  AsyncImageLoader.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/26/24.
//

import SwiftUI

struct AsyncImageLoader: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                LoadingView()
            case .success(let image):
                ResizableImageView(image: image)
            case .failure:
                Text("Failed to load image")
                    .foregroundColor(.red)
                    .frame(width: 100, height: 100)
            @unknown default:
                EmptyView()
            }
        }
    }
}
