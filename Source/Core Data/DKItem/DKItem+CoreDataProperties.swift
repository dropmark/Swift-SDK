//
//  DKItem+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/9/22.
//
//

import Foundation
import CoreData


extension DKItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKItem> {
        return NSFetchRequest<DKItem>(entityName: "DKItem")
    }

    @NSManaged public var collectionID: Int64
    @NSManaged public var collectionName: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var deletedAt: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int64
    @NSManaged public var isShareable: Bool
    @NSManaged public var isURL: Bool
    @NSManaged public var itemsTotalCount: NSNumber?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var link: URL?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var metadata: NSDictionary?
    @NSManaged public var mime: String?
    @NSManaged public var name: String?
    @NSManaged public var parentID: NSNumber?
    @NSManaged public var parentName: String?
    @NSManaged public var reactionsTotalCount: NSNumber?
    @NSManaged public var shortURL: URL?
    @NSManaged public var size: NSNumber?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var typeRaw: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: URL?
    @NSManaged public var thumbnails: DKThumbnails?

}

extension DKItem : Identifiable {

}
