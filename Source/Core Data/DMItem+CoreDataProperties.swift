//
//  DMItem+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 6/28/22.
//
//

import Foundation
import CoreData


extension DMItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DMItem> {
        return NSFetchRequest<DMItem>(entityName: "DMItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var collectionID: Int64
    @NSManaged public var collectionName: String?
    @NSManaged public var parentID: Int64
    @NSManaged public var parentName: String?
    @NSManaged public var name: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var content: String?
    @NSManaged public var link: URL?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var isShareable: Bool
    @NSManaged public var size: Int64
    @NSManaged public var typeRaw: String?
    @NSManaged public var mime: String?
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var deletedAt: Date?
    @NSManaged public var reactionsTotalCount: Int32
    @NSManaged public var url: URL?
    @NSManaged public var shortURL: URL?
    @NSManaged public var isURL: Bool
    @NSManaged public var metadata: NSDictionary?
    @NSManaged public var itemsTotalCount: Int32

}

extension DMItem : Identifiable {

}
