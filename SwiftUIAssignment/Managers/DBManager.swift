//
//  DBManager.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/23/24.
//

import Foundation
import CoreData

class DBManager {
    static let shared = DBManager()

    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "SwiftUIAssignment")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            } else {
                self.printCoreDataSQLiteFilePath()
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func fetchData<T: NSManagedObject>(entity: T.Type) -> [T] {
        let request = T.fetchRequest()
        do {
            return try context.fetch(request) as? [T] ?? []
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return []
        }
    }
    
    func addImageData(title: String, path: String) -> Bool {
        let imageEntity = Images(context: context)
        imageEntity.imageDescription = title
        imageEntity.imageFilePath = path
        
        return saveContext()
    }
    
    func addVideoData(userName: String, videoPath: String) -> Bool {
        let videoEntity = Videos(context: context)
        videoEntity.videoFileName = userName
        videoEntity.videoFilePath = videoPath
        
        return saveContext()
    }
    
    func deleteImage(imagePath: Images) -> Bool {
        context.delete(imagePath)
        return saveContext()
    }
    
    func deleteVideo(videoPath: Videos) -> Bool {
        context.delete(videoPath)
        return saveContext()
    }
    
    func deleteAllData(forEntity entity: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
            print("All data deleted for entity \(entity).")
        } catch let error as NSError {
            print("Could not delete all data in \(entity): \(error)")
        }
    }
    
    private func saveContext() -> Bool {
        do {
            try context.save()
            print("Changes saved successfully.")
            return true
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
            return false
        }
    }
    
    func printCoreDataSQLiteFilePath() {
        guard let storeURL = container.persistentStoreCoordinator.persistentStores.first?.url else {
            print("Failed to get the store URL")
            return
        }
        print("Core Data SQLite file path: \(storeURL.path)")
    }

    func addImageBookmark(bookmark: MediaBookmarkModel) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Images", in: context) else {
            print("Failed to create entity description for Images")
            return false
        }
        
        let newBookmark = NSManagedObject(entity: entity, insertInto: context) as! Images
        newBookmark.imageDescription = bookmark.name
        newBookmark.imageFilePath = bookmark.filePath
        
        print("Adding bookmark with file path: \(bookmark.filePath)")
        
        return saveContext()
    }
    
    func addVideoBookmark(bookmark: MediaBookmarkModel) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Videos", in: context) else {
            print("Failed to create entity description for Videos")
            return false
        }
        
        let newBookmark = NSManagedObject(entity: entity, insertInto: context) as! Videos
        newBookmark.videoFileName = bookmark.name
        newBookmark.videoFilePath = bookmark.filePath
        
        print("Adding bookmark with file path: \(bookmark.filePath)")
        
        return saveContext()
    }

    func deleteImageBookmark(filePath: String) -> Bool {
        let fetchRequest: NSFetchRequest<Images> = Images.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageFilePath == %@", filePath)
        
        do {
            let bookmarks = try context.fetch(fetchRequest)
            guard !bookmarks.isEmpty else {
                print("No bookmarks found for filePath: \(filePath)")
                return false
            }
            
            for bookmark in bookmarks {
                context.delete(bookmark)
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

    func deleteVideoBookmark(filePath: String) -> Bool {
        let fetchRequest: NSFetchRequest<Videos> = Videos.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "videoFilePath == %@", filePath)
        
        do {
            let bookmarks = try context.fetch(fetchRequest)
            guard !bookmarks.isEmpty else {
                print("No bookmarks found for filePath: \(filePath)")
                return false
            }
            
            for bookmark in bookmarks {
                context.delete(bookmark)
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

    func fetchImageBookmarks() -> [Images] {
        let fetchRequest: NSFetchRequest<Images> = Images.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch bookmarks: \(error.localizedDescription)")
            return []
        }
    }

    func fetchVideoBookmarks() -> [Videos] {
        let fetchRequest: NSFetchRequest<Videos> = Videos.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch bookmarks: \(error.localizedDescription)")
            return []
        }
    }
}
