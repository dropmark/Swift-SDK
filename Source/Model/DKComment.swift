//
//  DKComment.swift
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

/// Comments can be added to individual items.

@objc(DKComment)
public final class DKComment: NSObject, NSCoding, DKResponseObjectSerializable, DKResponseListSerializable {
    
    public var id : NSNumber!
    public var itemID: NSNumber?
    public var itemName: String?
    public var collectionID : NSNumber?
    public var collectionName : String?
    public var collectionURL : String?
    public var body : String!
    public var createdAt : Date!
    public var updatedAt : Date?
    public var annotation : String?
    public var URL : String?
    public var shortURL : String?
    public var user: DKUser?
    
    // MARK: DKResponseObjectSerializable
    
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? NSNumber,
            let body = representation["body"] as? String,
            let createdAtString = representation["created_at"] as? String
        else { return nil }
        
        self.id = id
        itemID = representation["item_id"] as? NSNumber
        itemName = representation["item_name"] as? String
        collectionID = representation["collection_id"] as? NSNumber
        collectionName = representation["collection_name"] as? String
        collectionURL = representation["collection_url"] as? String
        self.body = body
        createdAt = createdAtString.date
        if let updatedAtString = representation["updated_at"] as? String {
            updatedAt = updatedAtString.date
        }
        annotation = representation["annotation"] as? String
        URL = representation["url"] as? String
        shortURL = representation["short_url"] as? String
        
        if let userID = representation["user_id"] as? NSNumber, let user = DKUser(id: userID) {
            user.username = representation["username"] as? String
            if let name = representation["user_name"] as? String {
                user.name = name
            } else if let name = representation["name"] as? String {
                user.name = name
            }
            if let email = representation["user_email"] as? String {
                user.email = email
            } else if let email = representation["email"] as? String {
                user.email = email
            }
            if let avatar = representation["user_avatar"] as? String {
                user.avatar = avatar
            } else if let avatar = representation["avatar"] as? String {
                user.avatar = avatar
            }
            self.user = user
        }
        
    }
    
    // MARK: NSUserDefaults
    
    // Init from NSUserDefaults
    public required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as! NSNumber
        itemID = aDecoder.decodeObject(forKey: "item_id") as? NSNumber
        itemName = aDecoder.decodeObject(forKey: "item_name") as? String
        collectionID = aDecoder.decodeObject(forKey: "collection_id") as? NSNumber
        collectionName = aDecoder.decodeObject(forKey: "collection_name") as? String
        collectionURL = aDecoder.decodeObject(forKey: "collection_url") as? String
        body = aDecoder.decodeObject(forKey: "body") as! String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as! Date
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Date
        annotation = aDecoder.decodeObject(forKey: "annotation") as? String
        URL = aDecoder.decodeObject(forKey: "url") as? String
        shortURL = aDecoder.decodeObject(forKey: "short_url") as? String
        user = aDecoder.decodeObject(forKey: "user") as? DKUser
        
    }
    
    // Save to NSUserDefaults
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(itemID, forKey: "item_id")
        aCoder.encode(itemName, forKey: "item_name")
        aCoder.encode(collectionID, forKey: "collection_id")
        aCoder.encode(collectionName, forKey: "collection_name")
        aCoder.encode(collectionURL, forKey: "collection_url")
        aCoder.encode(body, forKey: "body")
        aCoder.encode(createdAt, forKey: "created_at")
        aCoder.encode(updatedAt, forKey: "updated_at")
        aCoder.encode(annotation, forKey: "annnotation")
        aCoder.encode(URL, forKey: "url")
        aCoder.encode(shortURL, forKey: "short_url")
        aCoder.encode(user, forKey: "user")
        
    }
    
}

// MARK: Equatable

public func ==(lhs: DKComment, rhs: DKComment) -> Bool {
    return lhs.id == rhs.id
}

public func ==(lhs: DKComment?, rhs: DKComment) -> Bool {
    return lhs?.id == rhs.id
}

public func ==(lhs: DKComment, rhs: DKComment?) -> Bool {
    return lhs.id == rhs?.id
}

public func ==(lhs: DKComment?, rhs: DKComment?) -> Bool {
    return lhs?.id == rhs?.id
}
