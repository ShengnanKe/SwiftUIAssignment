//
//  DBManager.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/23/24.
//

import CoreData
import UIKit

class DBManager {
    static let shared = DBManager()
    
    private init() {}
    
    // Existing methods for handling images
    func addImageData(title: String, fileName: String) {
        let context = persistentContainer.viewContext
        let imageEntity = Images(context: context)
        imageEntity.imageDescription = title
        imageEntity.imageFileName = fileName
        saveContext()
    }
    
    func getSQLiteFilePath() -> String? {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let sqlitePath = urls[0].appendingPathComponent("SwiftUIAssignment.sqlite").path
        return sqlitePath
    }
    
    func fetchData<T: NSManagedObject>(entity: T.Type) -> [T] {
        let context = persistentContainer.viewContext
        let request = T.fetchRequest()
        do {
            return try context.fetch(request) as! [T]
        } catch {
            print("Failed to fetch data: \(error)")
            return []
        }
    }
    
    func deleteImage(imageEntity: Images) {
        let context = persistentContainer.viewContext
        context.delete(imageEntity)
        saveContext()
    }
    
    func addVideoData(userName: String, fileName: String) {
        let context = persistentContainer.viewContext
        let videoEntity = Videos(context: context)
        videoEntity.videoUserName = userName
        videoEntity.videoFileName = fileName
        saveContext()
    }
    
    func deleteVideo(videoEntity: Videos) {
        let context = persistentContainer.viewContext
        context.delete(videoEntity)
        saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwiftUIAssignment")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
