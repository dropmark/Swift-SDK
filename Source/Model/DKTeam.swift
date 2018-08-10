//
//  DKTeam.swift
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

/**
 
 Teams are similar to a user account – they have their own username, dashboard and subscription, but a team can be managed by multiple users.
 
 A user associated with a team can be a manager or a user. Managers have more privledges than a normal user and some API endpoints are limited to managers only.
 
 Teams can be added to a collection as a collaborator by `username` or `user_id` (use the team `id` for this).
 
 */
@objc(DKTeam)
public final class DKTeam: NSObject, NSCoding, DKResponseObjectSerializable, DKResponseListSerializable {
    
    /// A team's ability to act on the Dropmark platform
    public enum Status: String {
        
        /// A team retains the ability to act within Dropmark
        case active
        
        /// A team cannot act on Dropmark
        case inactive
        
    }
    
    /// The current user (as identified by the token supplied in the GET request) status within the team
    public enum UserKind: String {
        
        /// The current user manages this team
        case manager
        
        /// The current user is a collaborator on this team
        case user
        
    }
    
    /// Encapsulates the data usage metrics for a team
    public struct Usage {
        
        /// The total amount of available data, in bytes
        public var quota: NSNumber
        
        /// The amount of data used by the team, in bytes
        public var usage: NSNumber
        
    }
    
    /// The unique identifier of the team
    public var id : NSNumber
    
    /// The name of a team
    public var name : String
    
    /// The primmary email associated with the team
    public var email : String?
    
    /// The unique username for the team
    public var username : String?
    
    
    public var customDomain : String?
    
    
    public var sortBy : String?
    
    
    public var sortOrder : String?
    
    
    public var viewMode : String?
    
    
    public var labels : Bool?
    
    /// The membership tier of the team
    public var plan : DKPlan = .free
    
    /// `true` if a paid membership is still active
    public var planIsActive : Bool?
    
    
    public var planQuantity : NSNumber?
    
    /// The primary email address associate with the teams billing account
    public var billingEmail : String?
    
    /// The active/inactive status of the team
    public var status : Status = .active
    
    /// The date the team was created
    public var createdAt : Date?
    
    /// A unique key used to assemble a Dropmark feed URL. Learn more about Dropmark feeds [here](https://www.dropmark.com/api/topics/feeds/).
    public var feedKey : String?
    
    /// The usage metrics of data for a team
    public var usage : Usage?
    
    /// The role of the current user (as identified by the token supplied in the GET request) within the team
    public var userKind : UserKind?
    
    /// All collaborators within the team
    public var users: [DKUser]?
    
    /// The URL of the team's avatar image
    public var avatar: URL?
    
    // MARK: DKResponseObjectSerializable
    
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? NSNumber,
            let name = representation["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        email = representation["email"] as? String
        username = representation["username"] as? String
        customDomain = representation["custom_domain"] as? String
        sortBy = representation["sort_by"] as? String
        sortOrder = representation["sort_order"] as? String
        viewMode = representation["view_mode"] as? String
        labels = representation["labels"] as? Bool
        
        if let planString = representation["user_plan"] as? String, let plan = DKPlan(rawValue: planString) {
            self.plan = plan
        }
        
        planIsActive = representation["plan_active"] as? Bool
        planQuantity = representation["plan_quantity"] as? NSNumber
        billingEmail = representation["billing_email"] as? String
        
        if let statusString = representation["status"] as? String, let status = Status(rawValue: statusString) {
            self.status = status
        }
        
        if let createdAtString = representation["created_at"] as? String {
            createdAt = createdAtString.date
        }
        
        feedKey = representation["feed_key"] as? String
        
        if let userKindString = representation["user_kind"] as? String {
            userKind = UserKind(rawValue: userKindString)
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
        
        if let avatarString = representation["avatar"] as? String {
            avatar =  URL(string: avatarString)
        } else if let avatarString = representation["user_avatar"] as? String {
            avatar =  URL(string: avatarString)
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
            let name = aDecoder.decodeObject(forKey: "name") as? String
        else { return nil }
        
        self.id = id
        self.name = name
        email = aDecoder.decodeObject(forKey: "email") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        customDomain = aDecoder.decodeObject(forKey: "custom_domain") as? String
        sortBy = aDecoder.decodeObject(forKey: "sort_by") as? String
        sortOrder = aDecoder.decodeObject(forKey: "sort_order") as? String
        viewMode = aDecoder.decodeObject(forKey: "view_mode") as? String
        labels = aDecoder.decodeObject(forKey: "labels") as? Bool
        
        if let planString = aDecoder.decodeObject(forKey: "plan") as? String {
            plan = DKPlan(rawValue: planString) ?? .free
        }
        
        planIsActive = aDecoder.decodeObject(forKey: "plan_active") as? Bool
        planQuantity = aDecoder.decodeObject(forKey: "plan_quantity") as? NSNumber
        billingEmail = aDecoder.decodeObject(forKey: "billing_email") as? String
        
        if let statusString = aDecoder.decodeObject(forKey: "status") as? String {
            status = Status(rawValue: statusString) ?? .active
        }
        
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? Date
        feedKey = aDecoder.decodeObject(forKey: "feed_key") as? String
        
        if let userKindString = aDecoder.decodeObject(forKey: "user_kind") as? String {
            userKind = UserKind(rawValue: userKindString)
        }
        
        users = aDecoder.decodeObject(forKey: "users") as? [DKUser]
        avatar = aDecoder.decodeObject(forKey: "avatar") as? URL
        
    }
    
    /**
     
     Encodes the receiver using a given archiver.
     
     - Parameters:
        - encoder: An archiver object.
     
     */
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(customDomain, forKey: "custom_domain")
        aCoder.encode(sortBy, forKey: "sort_by")
        aCoder.encode(sortOrder, forKey: "sort_order")
        aCoder.encode(viewMode, forKey: "view_mode")
        aCoder.encode(labels, forKey: "labels")
        aCoder.encode(plan.rawValue, forKey: "plan")
        aCoder.encode(planIsActive, forKey: "plan_active")
        aCoder.encode(planQuantity, forKey: "plan_quantity")
        aCoder.encode(billingEmail, forKey: "billing_email")
        aCoder.encode(status.rawValue, forKey: "status")
        aCoder.encode(createdAt, forKey: "created_at")
        aCoder.encode(feedKey, forKey: "feed_key")
        aCoder.encode(userKind?.rawValue, forKey: "user_kind")
        aCoder.encode(users, forKey: "users")
        aCoder.encode(avatar, forKey: "avatar")
        
    }
    
}

/**
 
 Returns whether the two teams are equal.
 
 - Parameters:
     - lhs: The left-hand side value to compare.
     - rhs: The right-hand side value to compare.
 
 - Returns: `true` if the two values are equal, `false` otherwise.
 
 */

func ==(lhs: DKTeam?, rhs: DKTeam?) -> Bool {
    return lhs?.id == rhs?.id
}
