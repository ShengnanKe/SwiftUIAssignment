//
//  Videos+CoreDataProperties.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/24/24.
//
//

import Foundation
import CoreData


extension Videos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Videos> {
        return NSFetchRequest<Videos>(entityName: "Videos")
    }

    @NSManaged public var videoUserName: String?
    @NSManaged public var videoFileName: String?

}

extension Videos : Identifiable {

}
