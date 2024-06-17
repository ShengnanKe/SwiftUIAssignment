//
//  HomeView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            ImageView()
                .tabItem {
                    Image(systemName: "photo")
                    Text("Image")
                }
            VideoView()
                .tabItem {
                    Image(systemName: "video")
                    Text("Video")
                }
            BookmarkView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Bookmark")
                }
        }
    }
}

#Preview {
    HomeView()
}
