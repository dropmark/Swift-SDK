//
//  DKCollection+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/18/22.
//
//

import Foundation
import CoreData


extension DKCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKCollection> {
        return NSFetchRequest<DKCollection>(entityName: "DKCollection")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var customDomain: URL?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var isArchived: NSNumber?
    @NSManaged public var isHighlighted: NSNumber?
    @NSManaged public var itemsTotalCount: NSNumber?
    @NSManaged public var kindRaw: String?
    @NSManaged public var lastAccessedAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var shortURL: URL?
    @NSManaged public var showLabels: NSNumber?
    @NSManaged public var sort: NSNumber?
    @NSManaged public var sortByRaw: String?
    @NSManaged public var sortOrderRaw: String?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: URL?
    @NSManaged public var usersTotalCount: NSNumber?
    @NSManaged public var viewModeRaw: String?
    @NSManaged public var items: NSSet?
    @NSManaged public var thumbnails: DKThumbnails?
    @NSManaged public var creator: DKUser?
    @NSManaged public var users: DKUser?

}

// MARK: Generated accessors for items
extension DKCollection {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: DKItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: DKItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension DKCollection : Identifiable {

}
