//
//  DKReaction.swift
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

/// Reactions are essentially a way for a user to “Like” an item.
@objc(DKReaction)
public final class DKReaction: NSObject, NSCoding, DKResponseObjectSerializable, DKResponseListSerializable {
    
    /// The unique identifier of the reaction
    public var id : NSNumber
    
    /// The unique identifier for the associated item
    public var itemID : NSNumber
    
    /// The name of the associated item
    public var itemName: String?
    
    /// The unique identifier of the parent collection
    public var collectionID : NSNumber?
    
    /// The name of the parent collection
    public var collectionName: String?
    
    /// The date the reaction was created
    public var createdAt : Date
    
    /// The date the reaction was last updated
    public var updatedAt : Date?
    
    /// The creator of the reaction
    public var user: DKUser?
    
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
            let itemID = representation["item_id"] as? NSNumber,
            let createdAtString = representation["created_at"] as? String,
            let createdAt = createdAtString.date
        else { return nil }
        
        self.id = id
        self.itemID = itemID
        itemName = representation["item_name"] as? String
        collectionID = representation["collection_id"] as? NSNumber
        collectionName = representation["collection_name"] as? String
        self.createdAt = createdAt
        
        if let updatedAtString = representation["updated_at"] as? String {
            updatedAt = updatedAtString.date
        }
        
        if let userID = representation["user_id"] as? NSNumber {
            
            let user = DKUser(id: userID)
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
            
            if let avatarString = representation["user_avatar"] as? String, let avatar = URL(string: avatarString) {
                user.avatar = avatar
            } else if let avatarString = representation["avatar"] as? String, let avatar = URL(string: avatarString) {
                user.avatar = avatar
            }
            
            self.user = user
            
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
            let itemID = aDecoder.decodeObject(forKey: "item_id") as? NSNumber,
            let createdAt = aDecoder.decodeObject(forKey: "created_at") as? Date
        else { return nil }
        
        self.id = id
        self.itemID = itemID
        itemName = aDecoder.decodeObject(forKey: "item_name") as? String
        collectionID = aDecoder.decodeObject(forKey: "collection_id") as? NSNumber
        collectionName = aDecoder.decodeObject(forKey: "collection_name") as? String
        self.createdAt = createdAt
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Date
        user = aDecoder.decodeObject(forKey: "user") as? DKUser
        
    }
    
    /**
     
     Encodes the receiver using a given archiver.
     
     - Parameters:
        - encoder: An archiver object.
     
     */
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(itemID, forKey: "item_id")
        aCoder.encode(itemName, forKey: "item_name")
        aCoder.encode(collectionID, forKey: "collection_id")
        aCoder.encode(collectionName, forKey: "collection_name")
        aCoder.encode(createdAt, forKey: "created_at")
        aCoder.encode(updatedAt, forKey: "updated_at")
        aCoder.encode(user, forKey: "user")
        
    }
    
}

/**
 
 Returns whether the two reactions are equal.
 
 - Parameters:
     - lhs: The left-hand side value to compare.
     - rhs: The right-hand side value to compare.
 
 - Returns: `true` if the two values are equal, `false` otherwise.
 
 */

func ==(lhs: DKReaction?, rhs: DKReaction?) -> Bool {
    return lhs?.id == rhs?.id
}
