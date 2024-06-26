//
//  HomeView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var bookmarkViewModel: BookmarkViewModel

    init() {
        _bookmarkViewModel = StateObject(wrappedValue: BookmarkViewModel(context: PersistenceController.shared.container.viewContext))
    }

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
            BookmarkView(viewModel: bookmarkViewModel)
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
