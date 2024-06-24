//
//  FACacheManager.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/17/24.
//

import Foundation
import UIKit

class FACacheManager {
    private let imageCache = NSCache<NSString, UIImage>()
    private let videoCache = NSCache<NSString, NSURL>()

    init() {
        imageCache.countLimit = 100
        imageCache.totalCostLimit = 1024 * 1024 * 50 // 50 MB for images
        videoCache.countLimit = 10
        videoCache.totalCostLimit = 1024 * 1024 * 500 // 500 MB for videos
    }

    func getImage(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }

    func saveImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }

    func getVideoURL(forKey key: String) -> URL? {
        return videoCache.object(forKey: key as NSString) as URL?
    }

    func saveVideoURL(_ url: URL, forKey key: String) {
        videoCache.setObject(url as NSURL, forKey: key as NSString)
    }

    func removeImage(forKey key: String) {
        imageCache.removeObject(forKey: key as NSString)
    }

    func removeVideoURL(forKey key: String) {
        videoCache.removeObject(forKey: key as NSString)
    }

    func clearCache() {
        imageCache.removeAllObjects()
        videoCache.removeAllObjects()
    }
}
