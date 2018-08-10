//
//  DKCollection.swift
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

/// Collections are the main way things are organized in Dropmark. A collection has one owner, but has many items and users (AKA collaborators).
@objc(DKCollection)
public final class DKCollection: NSObject, NSCoding, DKResponseObjectSerializable, DKResponseListSerializable {
    
    /// Privacy of a collection (and it's items) are determined by the `Kind`
    public enum Kind : String {
        
        /// A collection (and it's items) is only accessible by the owner and team members
        case `private`
        
        /// A collection (and it's items) is available through a direct link, but is not indexed for public search
        case `public`
        
        /// A collection (and it's items) is publicly available and indexed for search
        case global
        
        /// An array containing all `Kind` cases
        static var allValues: [DKCollection.Kind] = [
            .private,
            .public,
            .global
        ]
        
    }
    
    /// Sorting methods for child items. Note: This variable is maintained by the Dropmark API, and may differ from local sorting methods.
    public enum SortBy : String {
        
        /// Sort by the date the collection was created
        case createdAt = "created_at"
        
        /// Sort by the date the collection was last updated
        case updatedAt = "updated_at"
        
        /// Sort alphabetically by name
        case name
        
        /// Sort by the `kind` type
        case `type`
        
        /// Sort by the number of items contained by the collection
        case size
        
        /// Sort by the number of reactions contained in the collection
        case reactions
        
        /// Manual sorting
        case null
        
    }
    
    /// Render items in an ascending or descending fashion, as dictated by the `sortBy` variable.
    public enum SortOrder : String {
        
        /// Sort in an ascending fashion
        case ascending = "asc"
        
        /// Sort in a descending fashion
        case descending = "desc"
        
    }
    
    /// Different styles of presentation of items, as maintained by the Dropmark API
    public enum ViewMode : String {
        
        /// Render items as a grid of tiles
        case tile
        
        /// Render items as a shelf
        case shelf
        
        /// Render items in a mason-style flow layout
        case flow
        
        /// Render items in a vertical list
        case list
        
    }
    
    /// The unique identifier of the collection
    public var id : NSNumber
    
    /// The name of a collection
    public var name : String
    
    /// Not to be confused with the `NSObject` `description`, this is the Dropmark-defined description of a collection
    public var descriptionText : String?
    
    /// The privacy setting of a collection (and it's items)
    public var kind : Kind?
    
    
    public var sort : NSNumber?
    
    /// Sorting method for items contained by the collection
    public var sortBy : SortBy?
    
    /// Sort items by `ascending` or `descending`
    public var sortOrder : SortOrder?
    
    /// The type of view to render the items by
    public var viewMode : ViewMode?
    
    /// User-defined thumbnail image URL, if available
    public var thumbnail : URL?
    
    
    public var labels : Bool?
    
    /// Returns `true` if the current user (as specified by the token in the network request) highighted this collection
    public var highlighted : Bool?
    
    /// A collection can be archived to remove it from a user's dashboard without permanently deleting it
    public var archived : Bool?
    
    /// The date the user last visited the collection
    public var lastAccessedAt : Date?
    
    /// The date the collection was created
    public var createdAt : Date
    
    /// The date the last time the collection was updated
    public var updatedAt : Date?
    
    /// A count of all items contained within a collection
    public var itemsTotalCount : NSNumber?
    
    
    public var customDomain : String?
    
    /// The total number of users and teams with access to this collection
    public var usersTotalCount : NSNumber?
    
    /// A link to the collection on Dropmark
    public var url : URL
    
    /// A shortened link to the collection on Dropmark
    public var shortURL : URL
    
    /// A suite of thumbnails generated by Dropmark
    public var thumbnails : DKThumbnails?
    
    /// Representation of which actions the current user can and cannot perform.
    public var permissions : DKPermissions?
    
    /// The creator of the collection
    public var user: DKUser?
    
    /// The collaborators associated with the collection
    public var users: [DKUser]?
    
    /// A list of items contained in the collection. Usually this is used to temporarily store up to 4 child items for a quadrant thumbnail, not as a store of all children items.
    public var items: [DKItem]?
    
    // MARK: DKResponseObjectSerializable
    
    public required init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? NSNumber,
            let name = representation["name"] as? String,
            let createdAtString = representation["created_at"] as? String,
            let createdAt = createdAtString.date,
            let urlString = representation["url"] as? String,
            let url = URL(string: urlString),
            let shortURLString = representation["short_url"] as? String,
            let shortURL = URL(string: shortURLString)
        else { return nil }
        
        self.id = id
        self.name = name
        descriptionText = representation["description"] as? String
        
        if let kindString = representation["type"] as? String {
            kind = Kind(rawValue: kindString)
        }
        
        self.sort = representation["sort"] as? NSNumber
        
        if let sortByString = representation["sort_by"] as? String {
            sortBy = SortBy(rawValue: sortByString)
        }
        
        if let sortOrderString = representation["sort_order"] as? String {
            sortOrder = SortOrder(rawValue: sortOrderString)
        }
        
        if let viewModeString = representation["view_mode"] as? String {
            viewMode = ViewMode(rawValue: viewModeString)
        }
        
        if let urlString = representation["thumbnail"] as? String {
            thumbnail = URL(string: urlString)
        }
        
        labels = representation["labels"] as? Bool
        highlighted = representation["highlighted"] as? Bool
        archived = representation["archived"] as? Bool
        
        if let lastAccessedAtString = representation["last_accessed_at"] as? String {
            lastAccessedAt = lastAccessedAtString.date
        }
        
        self.createdAt = createdAt
        
        if let updatedAtString = representation["updated_at"] as? String {
            self.updatedAt = updatedAtString.date
        }
        
        itemsTotalCount = representation["items_total_count"] as? NSNumber
        customDomain = representation["custom_domain"] as? String
        usersTotalCount = representation["users_total_count"] as? NSNumber
        self.url = url
        self.shortURL = shortURL
        
        if let thumbnailsRepresentation = representation["thumbnails"]  {
            thumbnails = DKThumbnails(response: response, representation: thumbnailsRepresentation)
        }
        
        if let permissionsRepresentation = representation["permissions"]  {
            permissions = DKPermissions(response: response, representation: permissionsRepresentation)
        }
        
        if let userID = representation["user_id"] as? NSNumber {
            
            let user = DKUser(id: userID)
            user.name = representation["user_name"] as? String
            user.username = representation["username"] as? String
            user.email = representation["user_email"] as? String
            
            if let avatarString = representation["user_avatar"] as? String, let avatar = URL(string: avatarString) {
                user.avatar = avatar
            }
            
            if let planString = representation["user_plan"] as? String, let plan = DKPlan(rawValue: planString) {
                user.plan = plan
            }
            
            user.planIsActive = representation["user_plan_active"] as? Bool
            self.user = user
            
        }
        
        if let userRepresentations = representation["users"] as? [Any] {
            
            var users = [DKUser]()
            
            for userRepresentation in userRepresentations {
                if let user = DKUser(response: response, representation: userRepresentation) {
                    users.append(user)
                }
            }
            
            self.users = users
            
        }
        
        if let itemRepresentations = representation["items"] as? [Any] {
            
            var items = [DKItem]()
            
            for itemRepresentation in itemRepresentations {
                if let item = DKItem(response: response, representation: itemRepresentation) {
                    items.append(item)
                }
            }
            
            self.items = items
            
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
            let name = aDecoder.decodeObject(forKey: "name") as? String,
            let createdAt = aDecoder.decodeObject(forKey: "created_at") as? Date,
            let url = aDecoder.decodeObject(forKey: "url") as? URL,
            let shortURL = aDecoder.decodeObject(forKey: "short_url") as? URL
        else { return nil }
        
        self.id = id
        self.name = name
        descriptionText = aDecoder.decodeObject(forKey: "description") as? String
        
        if let kindString = aDecoder.decodeObject(forKey: "type") as? String {
            kind = Kind(rawValue: kindString)
        }
        
        sort = aDecoder.decodeObject(forKey: "sort") as? NSNumber
        
        if let sortByString = aDecoder.decodeObject(forKey: "sort_by") as? String {
            sortBy = SortBy(rawValue: sortByString)
        }
        
        if let sortOrderString = aDecoder.decodeObject(forKey: "sort_order") as? String {
            sortOrder = SortOrder(rawValue: sortOrderString)
        }
        
        if let viewModeString = aDecoder.decodeObject(forKey: "view_mode") as? String {
            viewMode = ViewMode(rawValue: viewModeString)
        }
        
        thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? URL
        labels = aDecoder.decodeObject(forKey: "labels") as? Bool
        highlighted = aDecoder.decodeObject(forKey: "highlighted") as? Bool
        archived = aDecoder.decodeObject(forKey: "archived") as? Bool
        self.createdAt = createdAt
        lastAccessedAt = aDecoder.decodeObject(forKey: "last_accessed_at") as? Date
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Date
        itemsTotalCount = aDecoder.decodeObject(forKey: "items_total_count") as? NSNumber
        customDomain = aDecoder.decodeObject(forKey: "custom_domain") as? String
        usersTotalCount = aDecoder.decodeObject(forKey: "users_total_count") as? NSNumber
        self.url = url
        self.shortURL = shortURL
        thumbnails = aDecoder.decodeObject(forKey: "thumbnails") as? DKThumbnails
        permissions = aDecoder.decodeObject(forKey: "permissions") as? DKPermissions
        user = aDecoder.decodeObject(forKey: "user") as? DKUser
        
    }
    
    /**
     
     Encodes the receiver using a given archiver.
 
     - Parameters:
        - encoder: An archiver object.
     
     */
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(descriptionText, forKey: "description")
        aCoder.encode(kind?.rawValue, forKey: "type")
        aCoder.encode(sort, forKey: "sort")
        aCoder.encode(sortBy?.rawValue, forKey: "sort_by")
        aCoder.encode(sortOrder?.rawValue, forKey: "sort_order")
        aCoder.encode(viewMode?.rawValue, forKey: "view_mode")
        aCoder.encode(thumbnail, forKey: "thumbnail")
        aCoder.encode(labels, forKey: "labels")
        aCoder.encode(highlighted, forKey: "highlighted")
        aCoder.encode(archived, forKey: "archived")
        aCoder.encode(lastAccessedAt, forKey: "last_accessed_at")
        aCoder.encode(createdAt, forKey: "created_at")
        aCoder.encode(updatedAt, forKey: "updated_at")
        aCoder.encode(itemsTotalCount, forKey: "items_total_count")
        aCoder.encode(usersTotalCount, forKey: "users_total_count")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(shortURL, forKey: "short_url")
        aCoder.encode(thumbnails, forKey: "thumbnails")
        aCoder.encode(permissions, forKey: "permissions")
        aCoder.encode(user, forKey: "user")
        
    }
    
}

/**
 
 Returns whether the two collections are equal.
 
 - Parameters:
     - lhs: The left-hand side value to compare.
     - rhs: The right-hand side value to compare.
 
 - Returns: `true` if the two values are equal, `false` otherwise.
 
 */

public func ==(lhs: DKCollection?, rhs: DKCollection?) -> Bool {
    return lhs?.id == rhs?.id
}
