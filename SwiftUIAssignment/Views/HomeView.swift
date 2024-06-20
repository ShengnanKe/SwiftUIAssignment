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
            ImageSearchView()
                .tabItem {
                    Image(systemName: "photo")
                    Text("Image")
                }
            VideoSearchView()
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
