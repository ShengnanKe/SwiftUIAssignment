//
//  BookmarkManager.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import Foundation
import CoreData
import UIKit

class BookmarkManager: NSObject {
    static let shared = BookmarkManager()
    private var managedContext: NSManagedObjectContext
    
    private override init() {
        self.managedContext = PersistenceController.shared.container.viewContext
        super.init()
    }

    private func saveContext() -> Bool {
        do {
            try managedContext.save()
            print("Data saved!")
            return true
        } catch {
            print("Failed to save context: \(error)")
            return false
        }
    }
    
    func addBookmark(bookmark: MediaBookmarkModel) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "MediaBookmark", in: managedContext) else {
            print("Failed to create entity description for MediaBookmark")
            return false
        }
        
        let newBookmark = NSManagedObject(entity: entity, insertInto: managedContext) as! MediaBookmark
        newBookmark.name = bookmark.name
        newBookmark.url = bookmark.url
        newBookmark.filePath = bookmark.filePath
        
        print("Adding bookmark with file path: \(bookmark.filePath)")
        
        return saveContext()
    }
    
    func deleteBookmark(filePath: String) -> Bool {
        let fetchRequest: NSFetchRequest<MediaBookmark> = MediaBookmark.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "filePath == %@", filePath)
        
        do {
            let bookmarks = try managedContext.fetch(fetchRequest)
            guard !bookmarks.isEmpty else {
                print("No bookmarks found for filePath: \(filePath)")
                return false
            }
            
            for bookmark in bookmarks {
                managedContext.delete(bookmark)
            }
            
            if saveContext() {
                print("Deleted bookmark for filePath: \(filePath)")
                return true
            } else {
                print("Failed to save context after deleting bookmark")
                return false
            }
        } catch {
            print("Failed to fetch bookmarks for deletion: \(error)")
            return false
        }
    }

    func fetchBookmarks() -> [MediaBookmarkModel] {
        let fetchRequest: NSFetchRequest<MediaBookmark> = MediaBookmark.fetchRequest()
        
        do {
            let bookmarkEntities = try managedContext.fetch(fetchRequest)
            let bookmarks = bookmarkEntities.map { entity in
                MediaBookmarkModel(
                    name: entity.name ?? "",
                    url: entity.url ?? "",
                    filePath: entity.filePath ?? ""
                )
            }
            return bookmarks
        } catch {
            print("Failed to fetch bookmarks: \(error)")
            return []
        }
    }
}
