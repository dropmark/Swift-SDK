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

    @NSManaged public var collectionID: NSNumber // Altered from generated subclass
    @NSManaged public var collectionName: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: NSNumber // Altered from generated subclass
    @NSManaged public var itemID: NSNumber // Altered from generated subclass
    @NSManaged public var itemName: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var creator: DKUser?

}

extension DKReaction : Identifiable {

}
