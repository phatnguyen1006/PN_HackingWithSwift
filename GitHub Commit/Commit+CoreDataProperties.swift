//
//  Commit+CoreDataProperties.swift
//  GitHub Commit
//
//  Created by Phat Nguyen on 14/01/2022.
//
//

import Foundation
import CoreData


extension Commit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Entity")
    }

    @NSManaged public var sha: String
    @NSManaged public var url: String
    @NSManaged public var message: String
    @NSManaged public var date: Date

}

extension Commit : Identifiable {

}
