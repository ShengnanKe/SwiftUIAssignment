//
//  DBManager.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/23/24.
//

import Foundation
import CoreData

class DBManager: NSObject {
    
    var managedContext: NSManagedObjectContext!
    
    static let shared: DBManager = {
        let instance = DBManager()
        return instance
    }()
    
    private override init() {
        super.init()
        self.managedContext = PersistenceController.shared.container.viewContext
    }
    
    func fetchData<T: NSManagedObject>(entity: T.Type) -> [T] {
        let request = T.fetchRequest()
        do {
            return try managedContext.fetch(request) as? [T] ?? []
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return []
        }
    }
    
    func addImageData(title: String, path: String) -> Bool {
        let imageEntity = Images(context: managedContext)
        imageEntity.imageDescription = title
        imageEntity.imageFilePath = path
        
        return saveContext()
    }
    
    func addVideoData(userName: String, videoPath: String) -> Bool {
        let videoEntity = Videos(context: managedContext)
        videoEntity.videoFileName = userName
        videoEntity.videoFilePath = videoPath
        
        return saveContext()
    }
    
    func deleteImage(imagePath: Images) -> Bool {
        managedContext.delete(imagePath)
        return saveContext()
    }
    
    func deleteVideo(videoPath: Videos) -> Bool {
        managedContext.delete(videoPath)
        return saveContext()
    }
    
    func deleteAllData(forEntity entity: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
            saveContext()
            print("All data deleted for entity \(entity).")
        } catch let error as NSError {
            print("Could not delete all data in \(entity): \(error)")
        }
    }
    
    private func saveContext() -> Bool {
        do {
            try managedContext.save()
            print("Changes saved successfully.")
            return true
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
            return false
        }
    }
    
    func printCoreDataSQLiteFilePath() {
        guard let storeURL = managedContext.persistentStoreCoordinator?.persistentStores.first?.url else {
            print("Failed to get the store URL")
            return
        }
        print("Core Data SQLite file path: \(storeURL.path)")
    }
}
