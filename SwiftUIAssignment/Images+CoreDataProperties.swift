//
//  Images+CoreDataProperties.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/24/24.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var imageFileName: String?
    @NSManaged public var imageDescription: String?

}

extension Images : Identifiable {

}
