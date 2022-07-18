//
//  DKReaction+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/18/22.
//
//

import Foundation
import CoreData


extension DKReaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKReaction> {
        return NSFetchRequest<DKReaction>(entityName: "DKReaction")
    }

    @NSManaged public var collectionID: NSNumber?
    @NSManaged public var collectionName: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: NSNumber?
    @NSManaged public var itemID: NSNumber?
    @NSManaged public var itemName: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var item: DKItem?

}

extension DKReaction : Identifiable {

}
