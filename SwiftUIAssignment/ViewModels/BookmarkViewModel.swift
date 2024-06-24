//
//  BookmarkViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI

@MainActor
class BookmarkViewModel: ObservableObject {
    @Published var bookmarkedImages: [Images] = []
    @Published var bookmarkedVideos: [Videos] = []
    private let dbManager = DBManager.shared

    func fetchBookmarks() {
        bookmarkedImages = dbManager.fetchData(entity: Images.self)
        bookmarkedVideos = dbManager.fetchData(entity: Videos.self)
    }
}
