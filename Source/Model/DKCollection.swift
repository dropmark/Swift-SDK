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
    
    public var id : NSNumber!
    public var name : String!
    public var descriptionText : String?
    public var kind : Kind?
    public var sort : NSNumber?
    public var sortBy : SortBy?
    public var sortOrder : SortOrder?
    public var viewMode : ViewMode?
    public var thumbnail : URL?
    public var labels : Bool?
    public var highlighted : Bool?
    public var archived : Bool?
    public var lastAccessedAt : Date?
    public var createdAt : Date!
    public var updatedAt : Date?
    public var itemsTotalCount : NSNumber?
    public var customDomain : String?
    public var usersTotalCount : NSNumber?
    public var url : String!
    public var shortURL : String!
    public var thumbnails : DKThumbnails?
    public var permissions : DKPermissions?
    public var user: DKUser? // User that created the collection
    public var users: [DKUser]? // Collaborators
    public var items: [DKItem]?
    
    // MARK: DKResponseObjectSerializable
    
    public required init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? NSNumber,
            let name = representation["name"] as? String,
            let createdAtString = representation["created_at"] as? String,
            let url = representation["url"] as? String,
            let shortURL = representation["short_url"] as? String
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
        
        self.createdAt = createdAtString.date
        
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
        
        if let userID = representation["user_id"] as? NSNumber, let user = DKUser(id: userID) {
            user.name = representation["user_name"] as? String
            user.username = representation["username"] as? String
            user.email = representation["user_email"] as? String
            user.avatar = representation["user_avatar"] as? String
            if let planString = representation["user_plan"] as? String, let plan = DKUser.Plan(rawValue: planString) {
                user.plan = plan
            }
            user.planIsActive = representation["user_plan_active"] as? Bool
            self.user = user
        }
        
        if let usersRepresentation = representation["users"] as? [Any] {
            users = usersRepresentation.map({ DKUser(response:response, representation: $0)! })
        }
        
        if let itemsRepresentation = representation["items"] as? [Any] {
            items = itemsRepresentation.map({ DKItem(response:response, representation: $0)! })
        }
        
    }
    
    // MARK: NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as! NSNumber
        name = aDecoder.decodeObject(forKey: "name") as! String
        descriptionText = aDecoder.decodeObject(forKey: "description") as? String
        let kindString = aDecoder.decodeObject(forKey: "type") as! String
        kind = Kind(rawValue: kindString)
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
        createdAt = aDecoder.decodeObject(forKey: "created_at") as! Date
        lastAccessedAt = aDecoder.decodeObject(forKey: "last_accessed_at") as? Date
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Date
        itemsTotalCount = aDecoder.decodeObject(forKey: "items_total_count") as? NSNumber
        customDomain = aDecoder.decodeObject(forKey: "custom_domain") as? String
        usersTotalCount = aDecoder.decodeObject(forKey: "users_total_count") as? NSNumber
        url = aDecoder.decodeObject(forKey: "url") as! String
        shortURL = aDecoder.decodeObject(forKey: "short_url") as! String
        thumbnails = aDecoder.decodeObject(forKey: "thumbnails") as? DKThumbnails
        permissions = aDecoder.decodeObject(forKey: "permissions") as? DKPermissions
        user = aDecoder.decodeObject(forKey: "user") as? DKUser
        
    }
    
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
