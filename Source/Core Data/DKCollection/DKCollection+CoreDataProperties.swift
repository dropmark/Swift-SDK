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
    @NSManaged public var id: Int64
    @NSManaged public var isArchived: Bool
    @NSManaged public var isHighlighted: Bool
    @NSManaged public var itemsTotalCount: Int32
    @NSManaged public var kindRaw: String?
    @NSManaged public var lastAccessedAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var shortURL: URL?
    @NSManaged public var showLabels: Bool
    @NSManaged public var sort: Int32
    @NSManaged public var sortByRaw: String?
    @NSManaged public var sortOrderRaw: String?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: URL?
    @NSManaged public var usersTotalCount: Int32
    @NSManaged public var viewModeRaw: String?
    @NSManaged public var items: NSSet?

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
