//
//  DKItem.swift
//
//  Copyright © 2018 Oak, LLC (https://oak.is)
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

/// Items belong to a collection, can optionally belong to another item (a stack), and have many comments and reactions.
@objc(DKItem)
public final class DKItem: NSObject, NSCoding, DKResponseObjectSerializable, DKResponseListSerializable {
    
    public var id : NSNumber!
    public var collectionID : NSNumber!
    public var collectionName: String?
    public var parentID : NSNumber?
    public var parentName: String?
    public var name : String?
    public var descriptionText : String?
    public var content : Any?
    public var link : String?
    public var preview : String?
    public var thumbnail : URL?
    public var shareable : Bool?
    public var size : NSNumber?
    public var sort : NSNumber?
    public var type : DKItemType!
    public var mime : String?
    public var latitude : NSNumber?
    public var longitude : NSNumber?
    public var createdAt : Date!
    public var updatedAt : Date?
    public var deletedAt : Date?
    public var reactionsTotalCount : NSNumber?
    public var url : String!
    public var shortURL : String!
    public var thumbnails : DKThumbnails?
    public var isURL : Bool?
    public var tags : [DKTag]?
    public var metadata : [String: AnyObject]?
    public var items: [DKItem]?
    public var itemsTotalCount: NSNumber?
    public var user: DKUser?
    public var reactions : [DKReaction]?
    public var comments : [DKComment]?
    
    // MARK: DKResponseObjectSerializable
    
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? NSNumber,
            let collectionID = representation["collection_id"] as? NSNumber,
            let typeString = representation["type"] as? String,
            let createdAtString = representation["created_at"] as? String,
            let url = representation["url"] as? String,
            let shortURL = representation["short_url"] as? String
        else { return nil }
        
        self.id = id
        self.collectionID = collectionID
        collectionName = representation["collection_name"] as? String
        parentID = representation["parent_id"] as? NSNumber
        parentName = representation["parent_name"] as? String
        name = representation["name"] as? String
        descriptionText = representation["description"] as? String
        content = representation["content"]
        link = representation["link"] as? String
        preview = representation["preview"] as? String
        
        if let urlString = representation["thumbnail"] as? String {
            thumbnail = URL(string: urlString)
        }
        
        shareable = representation["shareable"] as? Bool
        size = representation["size"] as? NSNumber
        sort = representation["sort"] as? NSNumber
        type = DKItemType(rawValue: typeString) ?? .other
        mime = representation["mime"] as? String
        latitude = representation["latitude"] as? NSNumber
        longitude = representation["longitude"] as? NSNumber
        createdAt = createdAtString.date
        
        if let updatedAtString = representation["updated_at"] as? String {
            updatedAt = updatedAtString.date
        }
        
        if let deletedAtString = representation["deleted_at"] as? String {
            deletedAt = deletedAtString.date
        }
        
        reactionsTotalCount = representation["reactions_total_count"] as? NSNumber
        self.url = url
        self.shortURL = shortURL
        isURL = representation["is_url"] as? Bool
        
        if let thumbnailsRepresentation = representation["thumbnails"]  {
            thumbnails = DKThumbnails(response: response, representation: thumbnailsRepresentation)
        }
        
        if let metadataDict = representation["metadata"] as? [String: AnyObject] {
            metadata = metadataDict
        }
        
        if let itemsRepresentation = representation["items"] as? [AnyObject] {
            items = itemsRepresentation.map({ DKItem(response:response, representation: $0)! })
        }
        
        if let tagsRepresentation = representation["tags"] as? [AnyObject] {
            tags = tagsRepresentation.map({ DKTag(response:response, representation: $0)! })
        }
        
        itemsTotalCount = representation["items_total_count"] as? NSNumber
        
        if let userID = representation["user_id"] as? NSNumber, let user = DKUser(id: userID) {
            user.name = representation["user_name"] as? String
            user.email = representation["user_email"] as? String
            if let planString = representation["user_plan"] as? String, let plan = DKUser.Plan(rawValue: planString) {
                user.plan = plan
            }
            user.avatar = representation["user_avatar"] as? String
            self.user = user
        }
        
        if let reactionsRepresentation = representation["reactions"] as? [AnyObject] {
            reactions = reactionsRepresentation.map({ DKReaction(response:response, representation: $0)! })
        }
        
        if let commentsRepresentation = representation["comments"] as? [AnyObject] {
            let originalComments = commentsRepresentation.map({ DKComment(response:response, representation: $0)! })
            comments = originalComments.sorted(by: { $0.createdAt < $1.createdAt })
        }
        
    }
    
    // MARK: NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as! NSNumber
        collectionID = aDecoder.decodeObject(forKey: "collection_id") as! NSNumber
        collectionName = aDecoder.decodeObject(forKey: "collection_name") as? String
        parentID = aDecoder.decodeObject(forKey: "parent_id") as? NSNumber
        parentName = aDecoder.decodeObject(forKey: "parent_name") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        descriptionText = aDecoder.decodeObject(forKey: "description") as? String
        content = aDecoder.decodeObject(forKey: "content")
        link = aDecoder.decodeObject(forKey: "link") as? String
        preview = aDecoder.decodeObject(forKey: "preview") as? String
        thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? URL
        shareable = aDecoder.decodeObject(forKey: "shareable") as? Bool
        size = aDecoder.decodeObject(forKey: "size") as? NSNumber
        sort = aDecoder.decodeObject(forKey: "sort") as? NSNumber
        let typeString = aDecoder.decodeObject(forKey: "type") as! String
        type = DKItemType(rawValue: typeString) ?? .other
        mime = aDecoder.decodeObject(forKey: "mime") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? NSNumber
        longitude = aDecoder.decodeObject(forKey: "longitude") as? NSNumber
        createdAt = aDecoder.decodeObject(forKey: "created_at") as! Date
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Date
        deletedAt = aDecoder.decodeObject(forKey: "deleted_at") as? Date
        reactionsTotalCount = aDecoder.decodeObject(forKey: "reactions_total_count") as? NSNumber
        url = aDecoder.decodeObject(forKey: "url") as! String
        shortURL = aDecoder.decodeObject(forKey: "short_url") as! String
        isURL = aDecoder.decodeObject(forKey: "is_url") as? Bool
        thumbnails = aDecoder.decodeObject(forKey: "thumbnails") as? DKThumbnails
        metadata = aDecoder.decodeObject(forKey: "metadata") as? [String: AnyObject]
        items = aDecoder.decodeObject(forKey: "items") as? [DKItem]
        tags = aDecoder.decodeObject(forKey: "tags") as? [DKTag]
        itemsTotalCount = aDecoder.decodeObject(forKey: "items_total_count") as? NSNumber
        user = aDecoder.decodeObject(forKey: "user") as? DKUser
        
    }
    
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
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
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
