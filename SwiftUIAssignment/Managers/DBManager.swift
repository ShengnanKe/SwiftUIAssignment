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
    var context: NSManagedObjectContext!
    
    private init() {}
    
    
    func addImageData(title: String, fileName: String) {
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
        guard let context = context else {
            print("Context is not set up.")
            return []
        }
        let request = T.fetchRequest()
        do {
            return try context.fetch(request) as! [T]
        } catch {
            print("Failed to fetch data: \(error)")
            return []
        }
    }
    
    func deleteImage(imageEntity: Images) {
        context.delete(imageEntity)
        saveContext()
    }
    
    func addVideoData(userName: String, fileName: String) {
        let videoEntity = Videos(context: context)
        videoEntity.videoUserName = userName
        videoEntity.videoFileName = fileName
        saveContext()
    }
    
    func deleteVideo(videoEntity: Videos) {
        context.delete(videoEntity)
        saveContext()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    
}
