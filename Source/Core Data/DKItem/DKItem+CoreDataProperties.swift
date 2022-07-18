//
//  DKItem+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/18/22.
//
//

import Foundation
import CoreData


extension DKItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKItem> {
        return NSFetchRequest<DKItem>(entityName: "DKItem")
    }

    @NSManaged public var collectionID: NSNumber // Altered from generated subclass
    @NSManaged public var collectionName: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var deletedAt: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: NSNumber // Altered from generated subclass
    @NSManaged public var isShareable: NSNumber?
    @NSManaged public var isURL: NSNumber?
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
    @NSManaged public var comments: Set<DKComment>? // Altered from generated subclass
    @NSManaged public var reactions: Set<DKReaction>? // Altered from generated subclass
    @NSManaged public var thumbnails: DKThumbnails?
    @NSManaged public var collection: DKCollection?
    @NSManaged public var items: Set<DKItem>? // Altered from generated subclass
    @NSManaged public var stack: DKItem?
    @NSManaged public var tags: Set<DKTag>? // Altered from generated subclass

}

// MARK: Generated accessors for comments
extension DKItem {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: DKComment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: DKComment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

// MARK: Generated accessors for reactions
extension DKItem {

    @objc(addReactionsObject:)
    @NSManaged public func addToReactions(_ value: DKReaction)

    @objc(removeReactionsObject:)
    @NSManaged public func removeFromReactions(_ value: DKReaction)

    @objc(addReactions:)
    @NSManaged public func addToReactions(_ values: NSSet)

    @objc(removeReactions:)
    @NSManaged public func removeFromReactions(_ values: NSSet)

}

// MARK: Generated accessors for items
extension DKItem {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: DKItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: DKItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension DKItem {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: DKTag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: DKTag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension DKItem : Identifiable {

}
