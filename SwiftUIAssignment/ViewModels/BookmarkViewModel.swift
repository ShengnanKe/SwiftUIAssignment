//
//  BookmarkViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import SwiftUI
import CoreData


class BookmarkViewModel: ObservableObject {
    @Published var bookmarkedImages: [Images] = []
    @Published var bookmarkedVideos: [Videos] = []

    func setup(context: NSManagedObjectContext) {
        DBManager.shared.context = context
    }
    
    private let dbManager = DBManager.shared

    func fetchBookmarks() {
        bookmarkedImages = dbManager.fetchData(entity: Images.self)
        bookmarkedVideos = dbManager.fetchData(entity: Videos.self)

        print("Downloaded Image Paths:")
        for image in bookmarkedImages {
            if let imagePath = image.imageFileName {
                print(imagePath)
            }
        }

        // Print paths of downloaded videos
        print("Downloaded Video Paths:")
        for video in bookmarkedVideos {
            if let videoPath = video.videoFileName {
                print(videoPath)
            }
        }
    }
}
