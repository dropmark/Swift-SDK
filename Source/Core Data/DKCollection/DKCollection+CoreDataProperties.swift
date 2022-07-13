//
//  DKCollection+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/13/22.
//
//

import Foundation
import CoreData


extension DKCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKCollection> {
        return NSFetchRequest<DKCollection>(entityName: "DKCollection")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int64
    @NSManaged public var isArchived: Bool
    @NSManaged public var isHighlighted: Bool
    @NSManaged public var itemsTotalCount: NSNumber?
    @NSManaged public var kindRaw: String?
    @NSManaged public var lastAccessedAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var shortURL: URL?
    @NSManaged public var showLabels: Bool
    @NSManaged public var sort: NSNumber?
    @NSManaged public var sortByRaw: String?
    @NSManaged public var sortOrderRaw: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: URL?
    @NSManaged public var usersTotalCount: Int32
    @NSManaged public var viewModeRaw: String?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var customDomain: URL?

}

extension DKCollection : Identifiable {

}
