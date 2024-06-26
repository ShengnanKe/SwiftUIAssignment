//
//  BookmarkViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI
import CoreData

@MainActor
class BookmarkViewModel: ObservableObject {
    @Published var bookmarkedImages: [Images] = []
    @Published var bookmarkedVideos: [Videos] = []
    private let dbManager = DBManager.shared
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchBookmarks()
    }

    func fetchBookmarks() {
        bookmarkedImages = dbManager.fetchData(entity: Images.self)
        bookmarkedVideos = dbManager.fetchData(entity: Videos.self)
    }
}
