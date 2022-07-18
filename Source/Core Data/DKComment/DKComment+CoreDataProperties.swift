//
//  DKComment+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/18/22.
//
//

import Foundation
import CoreData


extension DKComment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKComment> {
        return NSFetchRequest<DKComment>(entityName: "DKComment")
    }

    @NSManaged public var annotation: URL?
    @NSManaged public var body: String?
    @NSManaged public var collectionID: NSNumber?
    @NSManaged public var collectionName: String?
    @NSManaged public var collectionURL: URL?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: NSNumber?
    @NSManaged public var itemID: NSNumber?
    @NSManaged public var itemName: String?
    @NSManaged public var shortURL: URL?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: URL?
    @NSManaged public var item: DKItem?

}

extension DKComment : Identifiable {

}
