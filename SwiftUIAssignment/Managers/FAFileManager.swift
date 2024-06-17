//
//  FAFileManager.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import Foundation
import UIKit

class FAFileManager: NSObject {
    static let shared: FAFileManager = {
        let instance = FAFileManager()
        return instance
    }()
    private override init() {
        super.init()
    }
    func saveImageToDocumentsDirectory(id: String, image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil}
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileName = "\(id).jpg"
        let photoDirectory = documentsDirectory.appendingPathComponent("photos")
        if !FileManager.default.fileExists(atPath: photoDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: photoDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error)
                return nil
            }
        }
        let fileURL = photoDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            //             print("Image saved: \(fileURL)")
            //             print("Image saved path: \(fileURL.path)")
            //             return fileURL.absoluteString
            return fileURL.path
        } catch {
            print("Error saving image: \(error)")
        }
        return nil
    }
    
    func loadImageFromDirectory(imageName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentsDirectory.appendingPathComponent("photos").appendingPathComponent(imageName)
        
        if FileManager.default.fileExists(atPath: imagePath.path) {
            if let image = UIImage(contentsOfFile: imagePath.path) {
                return image
            } else {
                print("Could not create UIImage from \(imagePath)")
                return nil
            }
        } else {
            print("No file found at \(imagePath)")
            return nil
        }
    }
}
