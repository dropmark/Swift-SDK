//
//  DKItem.swift
//
//  Copyright © 2020 Oak, LLC (https://oak.is)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import CoreLocation

/// Items belong to a collection, can optionally belong to another item (a stack), and have many comments and reactions.
@objc(DKItem)
public final class DKItem: NSObject, NSCoding, DKResponseObjectSerializable, DKResponseListSerializable {
        
    /// The unique identifier of the item
    public var id : NSNumber
    
    /// The unique identifier of the parent collection
    public var collectionID : NSNumber
    
    /// The name of the parent collection
    public var collectionName: String?
    
    /// The unique identifier of the parent stack
    public var parentID : NSNumber?
    
    /// The name of the parent stack
    public var parentName: String?
    
    /// The name of the item
    public var name : String?
    
    /// Not to be confused with the `NSObject` `description`, this is the Dropmark-defined description of an item
    public var descriptionText : String?
    
    /// Content may contain a multitude of types. Usually the content takes the form of a string, which may in turn represent a URL
    public var content : Any?
    
    /// A link to the content, external to Dropmark
    public var link : URL?
    
    
    public var preview : String?
    
    /// User-defined thumbnail image URL, if available
    public var thumbnail : URL?
    
    /// `true` if the item is available to share via a link
    public var shareable : Bool?
    
    /// The size in bytes, if applicable, of the content
    public var size : NSNumber?
    
    
    public var sort : NSNumber?
    
    /// The high level representation of the content. See the documentation of `DKItemType` for a richer understanding of when to reference an item's type
    public var type : DKItemType = .other
    
    /// The MIME type as derived by Dropmark
    public var mime : String?
    
    /// If available, the location the item's content was created
    public var location: CLLocation?
    
    /// The date the item was created
    public var createdAt : Date
    
    /// The date the last time the item was updated
    public var updatedAt : Date?
    
    /// The date the item was marked for deletion
    public var deletedAt : Date?
    
    /// The total number of reactions (or "likes") recieved by the item
    public var reactionsTotalCount : NSNumber = 0
    
    /// A link to the item on Dropmark. Note: The item must be `shareable` to view this link.
    public var url : URL
    
    /// A shortened link to the item on Dropmark. Note: The item must be `shareable` to view this link.
    public var shortURL : URL
    
    /// A suite of thumbnails generated by Dropmark
    public var thumbnails : DKThumbnails?
    
    /// `true` if the content contains a URL. Note: Always test the content yourself, use this only for preview/UI rendering
    public var isURL : Bool?
    
    /// A list of tags applied to this item
    public var tags = [DKTag]()
    
    /// Contains a range of other data associated with the item's content. For example, an image item may contain the image's EXIF data as a key-value set
    public var metadata : [String: AnyObject]?
    
    /// If the item is a stack, this contains a list of child items. Usually this is used to temporarily store up to 4 child items for a quadrant thumbnail, not as a store of all children items.
    public var items: [DKItem]?
    
    /// If the item is a stack, this is the total number of child items
    public var itemsTotalCount: NSNumber?
    
    /// The creator of the item
    public var user: DKUser
    
    /// The reactions (or "likes") the item recieved
    public var reactions = [DKReaction]()
    
    /// The comments the item recieved
    public var comments = [DKComment]()
    
    /// The effective file path for an item on Dropmark's servers
    public var directory: DKDirectory {
        return DKDirectory(collectionID: collectionID, stackID: parentID)
    }
    
    
    // MARK: DKResponseObjectSerializable
    
    /**
     
     Serializes a new instance from the provided network response and key-value representation. The representation is validated for the required parameters, then fills in optional parameters as necessary.
     
     - Parameters:
        - response: A network response assocated with serialization
        - representation: A key-value object representing parameters and child objects.
     
     */
    
    public init?(response: HTTPURLResponse, representation: Any) {

        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? NSNumber,
            let collectionID = representation["collection_id"] as? NSNumber,
            let createdAtString = representation["created_at"] as? String,
            let createdAt = DKDateFormatter().date(from: createdAtString),
            let urlString = representation["url"] as? String,
            let url = URL(string: urlString),
            let shortURLString = representation["short_url"] as? String,
            let shortURL = URL(string: shortURLString),
            let userID = representation["user_id"] as? NSNumber,
            let userName = representation["user_name"] as? String
        else { return nil }
        
        self.id = id
        self.collectionID = collectionID
        collectionName = representation["collection_name"] as? String
        parentID = representation["parent_id"] as? NSNumber
        parentName = representation["parent_name"] as? String
        name = representation["name"] as? String
        descriptionText = representation["description"] as? String
        content = representation["content"]
        
        if let linkString = representation["link"] as? String {
            self.link = URL(string: linkString)
        }
        
        preview = representation["preview"] as? String
        
        if let urlString = representation["thumbnail"] as? String {
            thumbnail = URL(string: urlString)
        }
        
        shareable = representation["shareable"] as? Bool
        size = representation["size"] as? NSNumber
        sort = representation["sort"] as? NSNumber
        
        if let typeString = representation["type"] as? String, let type = DKItemType(rawValue: typeString) {
            self.type = type
        }
        
        mime = representation["mime"] as? String
        
        if
            let latitude = representation["latitude"] as? NSNumber,
            let longitude = representation["longitude"] as? NSNumber
        {
            location = CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
        }
        
        self.createdAt = createdAt
        
        if let updatedAtString = representation["updated_at"] as? String {
            updatedAt = DKDateFormatter().date(from: updatedAtString)
        }
        
        if let deletedAtString = representation["deleted_at"] as? String {
            deletedAt = DKDateFormatter().date(from: deletedAtString)
        }
        
        if let reactionsTotalCount = representation["reactions_total_count"] as? NSNumber {
            self.reactionsTotalCount = reactionsTotalCount
        }
        
        self.url = url
        self.shortURL = shortURL
        isURL = representation["is_url"] as? Bool
        
        if let thumbnailsRepresentation = representation["thumbnails"]  {
            thumbnails = DKThumbnails(response: response, representation: thumbnailsRepresentation)
        }
        
        if let metadataDict = representation["metadata"] as? [String: AnyObject] {
            metadata = metadataDict
        }
        
        if let itemRepresentations = representation["items"] as? [Any] {
            items = itemRepresentations.compactMap{ DKItem(response: response, representation: $0) }
        }
        
        if let tagRepresentations = representation["tags"] as? [Any] {
            tags = tagRepresentations.compactMap{ DKTag(response: response, representation: $0) }
        }
        
        itemsTotalCount = representation["items_total_count"] as? NSNumber
        
        // Begin User
        
        let user = DKUser(id: userID)
        user.name = userName
        user.email = representation["user_email"] as? String
        
        if let planString = representation["user_plan"] as? String, let plan = DKPlan(rawValue: planString) {
            user.plan = plan
        }
        
        if let avatarString = representation["user_avatar"] as? String, let avatar = URL(string: avatarString) {
            user.avatar = avatar
        }
        
        self.user = user
        
        // End User
        
        if let reactionRepresentations = representation["reactions"] as? [Any] {
            reactions = reactionRepresentations.compactMap{ DKReaction(response: response, representation: $0) }
        }
        
        if let commentRepresentations = representation["comments"] as? [Any] {
            
            var descendingComments = commentRepresentations.compactMap{ DKComment(response: response, representation: $0) }
            
            // Comments are often rendered from last to first
            descendingComments.sort(by: { $0.createdAt < $1.createdAt })
            
            comments = descendingComments
            
        }
        
    }
    
    // MARK: NSCoding
    
    /**
     
     Returns an object initialized from data in a given unarchiver.
     
     - Parameters:
        - coder: An unarchiver object.
     
     - Returns: `self`, initialized using the data in `coder`.
     
     - Discussion: You typically return `self` from `init(coder:)`. If you have an advanced need that requires substituting a different object after decoding, you can do so in `awakeAfter(using:)`.
     
     */
    
    public required init?(coder aDecoder: NSCoder) {
        
        guard
            let id = aDecoder.decodeObject(forKey: "id") as? NSNumber,
            let collectionID = aDecoder.decodeObject(forKey: "collection_id") as? NSNumber,
            let createdAt = aDecoder.decodeObject(forKey: "created_at") as? Date,
            let url = aDecoder.decodeObject(forKey: "url") as? URL,
            let shortURL = aDecoder.decodeObject(forKey: "short_url") as? URL,
            let user = aDecoder.decodeObject(forKey: "user") as? DKUser
        else { return nil }
        
        self.id = id
        self.collectionID = collectionID
        collectionName = aDecoder.decodeObject(forKey: "collection_name") as? String
        parentID = aDecoder.decodeObject(forKey: "parent_id") as? NSNumber
        parentName = aDecoder.decodeObject(forKey: "parent_name") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        descriptionText = aDecoder.decodeObject(forKey: "description") as? String
        content = aDecoder.decodeObject(forKey: "content")
        link = aDecoder.decodeObject(forKey: "link") as? URL
        preview = aDecoder.decodeObject(forKey: "preview") as? String
        thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? URL
        shareable = aDecoder.decodeObject(forKey: "shareable") as? Bool
        size = aDecoder.decodeObject(forKey: "size") as? NSNumber
        sort = aDecoder.decodeObject(forKey: "sort") as? NSNumber
        
        if let typeString = aDecoder.decodeObject(forKey: "type") as? String, let type = DKItemType(rawValue: typeString) {
            self.type = type
        }
        
        mime = aDecoder.decodeObject(forKey: "mime") as? String
        location = aDecoder.decodeObject(forKey: "location") as? CLLocation
        self.createdAt = createdAt
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Date
        deletedAt = aDecoder.decodeObject(forKey: "deleted_at") as? Date
        
        if let reactionsTotalCount = aDecoder.decodeObject(forKey: "reactions_total_count") as? NSNumber {
            self.reactionsTotalCount = reactionsTotalCount
        }
        
        self.url = url
        self.shortURL = shortURL
        isURL = aDecoder.decodeObject(forKey: "is_url") as? Bool
        thumbnails = aDecoder.decodeObject(forKey: "thumbnails") as? DKThumbnails
        metadata = aDecoder.decodeObject(forKey: "metadata") as? [String: AnyObject]
        items = aDecoder.decodeObject(forKey: "items") as? [DKItem]
        
        if let tags = aDecoder.decodeObject(forKey: "tags") as? [DKTag] {
            self.tags = tags
        }
        
        itemsTotalCount = aDecoder.decodeObject(forKey: "items_total_count") as? NSNumber
        self.user = user
        
    }
    
    /**
     
     Encodes the receiver using a given archiver.
     
     - Parameters:
        - encoder: An archiver object.
     
     */
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(collectionID, forKey: "collection_id")
        aCoder.encode(collectionName, forKey: "collection_name")
        aCoder.encode(parentID, forKey: "parent_id")
        aCoder.encode(parentName, forKey: "parent_name")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(descriptionText, forKey: "description")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(thumbnail, forKey: "thumbnail")
        aCoder.encode(shareable, forKey: "shareable")
        aCoder.encode(size, forKey: "size")
        aCoder.encode(sort, forKey: "sort")
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(mime, forKey: "mime")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(createdAt, forKey: "created_at")
        aCoder.encode(updatedAt, forKey: "updated_at")
        aCoder.encode(deletedAt, forKey: "deleted_at")
        aCoder.encode(reactionsTotalCount, forKey: "reactions_total_count")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(shortURL, forKey: "short_url")
        aCoder.encode(thumbnails, forKey: "thumbnails")
        aCoder.encode(isURL, forKey: "is_url")
        aCoder.encode(tags, forKey: "tags")
        aCoder.encode(metadata, forKey: "metadata")
        aCoder.encode(items, forKey: "items")
        aCoder.encode(itemsTotalCount, forKey: "items_total_count")
        aCoder.encode(user, forKey: "user")
        
    }
    
}

/**
 
 Returns whether the two items are equal.
 
 - Parameters:
     - lhs: The left-hand side value to compare.
     - rhs: The right-hand side value to compare.
 
 - Returns: `true` if the two values are equal, `false` otherwise.
 
 */

public func ==(lhs: DKItem?, rhs: DKItem?) -> Bool {
    return lhs?.id == rhs?.id
}
