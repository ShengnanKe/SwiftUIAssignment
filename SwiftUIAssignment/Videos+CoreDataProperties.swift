//
//  Videos+CoreDataProperties.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/23/24.
//
//

import Foundation
import CoreData


extension Videos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Videos> {
        return NSFetchRequest<Videos>(entityName: "Videos")
    }

    @NSManaged public var videoFilePath: String?
    @NSManaged public var videoFileName: String?

}

extension Videos : Identifiable {

}
