//
//  DKUser.swift
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
 
 Represents a user on Dropmark. Can be the current user, collaborators, or users external to your team.
 
    - Note: Only when a user is retrieved from the `/auth` API endpoint will a `token` be returned
 
 */
@objc(DKUser)
public final class DKUser: NSObject, NSCoding, DKResponseObjectSerializable, DKResponseListSerializable {
    
    /// When listing collaborators within a collection, a `Kind` represents a user's role within the collection
    public enum Kind: String, CaseIterable {
        
        /// The owner of the collection can add, update, and delete collaborators, as well as alter the collection
        case owner
        
        /// The creator originally created the collection, however ownership can be transferred thereafter
        case creator
        
        /// A role assigned to users to administer the collection
        case manager
        
        /// A read-only member of a collection
        case user
        
    }
    
    /// A user's ability to act on the Dropmark platform
    public enum Status: String, CaseIterable {
        
        /// A user retains the ability to act within Dropmark
        case active
        
        /// A user cannot act on Dropmark
        case inactive
        
    }
    
    /// The unique identifier of the user
    public var id : NSNumber
    
    /// The name of the user
    public var name : String?
    
    /// The primary email of the user
    public var email : String?
    
    /// The unique username of the user
    public var username : String?
    
    
    public var customDomain : String?
    
    
    public var sortBy : String?
    
    
    public var sortOrder : String?
    
    
    public var viewMode : String?
    
    
    public var labels : Bool?
    
    /// The membership tier of the user
    public var plan : DKPlan = .free
    
    /// `true` if a paid membership is still active
    public var planIsActive : Bool?
    
    
    public var planQuantity : NSNumber?
    
    /// The primary email address associate with the teams billing account
    public var billingEmail : String?
    
    /// A user's role within a collection
    public var kind: Kind?
    
    /// The active/inactive status of the user
    public var status : Status = .active
    
    /// The date the user created their account
    public var createdAt : Date?
    
    /// The URL of the user's avatar image
    public var avatar: URL?
    
    /// A list of all teams of which the user is a member.
    public var teams: [DKTeam]?
    
    /// Used to authenticate requests on behalf of the user. **Note**: A token value only returns from the `/auth` API endpoint
    public var token: String?
    
    /**
     
     Initialize a local instance with an ID
     
     - Parameters:
        - id: The unique ID number to identify this user
     
     */
    
    public init(id: NSNumber) {
        self.id = id
    }
    
    // MARK: DKResponseObjectSerializable
    
    /**
     
     Serializes a new instance from the provided network response and key-value representation. The representation is validated for the required parameters, then fills in optional parameters as necessary.
     
     - Parameters:
        - response: A network response assocated with serialization
        - representation: A key-value object representing parameters and child objects.
     
     */
    
    public required init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? NSNumber
        else { return nil }
        
        self.id = id
        name = representation["name"] as? String
        email = representation["email"] as? String
        username = representation["username"] as? String
        customDomain = representation["custom_domain"] as? String
        sortBy = representation["sort_by"] as? String
        sortOrder = representation["sort_order"] as? String
        viewMode = representation["view_mode"] as? String
        labels = representation["labels"] as? Bool
        
        if let planString = representation["plan"] as? String, let plan = DKPlan(rawValue: planString) {
            self.plan = plan
        }
        
        planIsActive = representation["plan_active"] as? Bool
        planQuantity = representation["plan_quantity"] as? NSNumber
        billingEmail = representation["billing_email"] as? String
        
        if let kindString = representation["kind"] as? String, let kind = Kind(rawValue: kindString) {
            self.kind = kind
        }
        
        if let statusString = representation["status"] as? String, let status = Status(rawValue: statusString) {
            self.status = status
        }
        
        if let createdAtString = representation["created_at"] as? String {
            createdAt = createdAtString.date
        }
        
        if let avatarString = representation["avatar"] as? String {
            avatar =  URL(string: avatarString)
        } else if let avatarString = representation["user_avatar"] as? String {
            avatar =  URL(string: avatarString)
        }
        
        if let teamRepresentations = representation["teams"] as? [Any] {
            teams = teamRepresentations.compactMap{ DKTeam(response: response, representation: $0) }
        }
        
        token = representation["token"] as? String

    }
    
    // MARK: NSCoder
    
    /**
     
     Returns an object initialized from data in a given unarchiver.
     
     - Parameters:
        - coder: An unarchiver object.
     
     - Returns: `self`, initialized using the data in `coder`.
     
     - Discussion: You typically return `self` from `init(coder:)`. If you have an advanced need that requires substituting a different object after decoding, you can do so in `awakeAfter(using:)`.
     
     */
    
    public required init?(coder aDecoder: NSCoder) {
        
        guard
            let id = aDecoder.decodeObject(forKey: "id") as? NSNumber
        else { return nil}
        
        self.id = id
        name = aDecoder.decodeObject(forKey: "name") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        customDomain = aDecoder.decodeObject(forKey: "custom_domain") as? String
        sortBy = aDecoder.decodeObject(forKey: "sort_by") as? String
        sortOrder = aDecoder.decodeObject(forKey: "sort_order") as? String
        viewMode = aDecoder.decodeObject(forKey: "view_mode") as? String
        labels = aDecoder.decodeObject(forKey: "labels") as? Bool
        
        if let planString = aDecoder.decodeObject(forKey: "plan") as? String, let plan = DKPlan(rawValue: planString) {
            self.plan = plan
        }
        
        planIsActive = aDecoder.decodeObject(forKey: "plan_active") as? Bool
        planQuantity = aDecoder.decodeObject(forKey: "plan_quantity") as? NSNumber
        billingEmail = aDecoder.decodeObject(forKey: "billing_email") as? String
        
        if let statusString = aDecoder.decodeObject(forKey: "status") as? String, let status = Status(rawValue: statusString) {
            self.status = status
        }
        
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? Date
        avatar = aDecoder.decodeObject(forKey: "avatar") as? URL
        teams = aDecoder.decodeObject(forKey: "teams") as? [DKTeam]
        token = aDecoder.decodeObject(forKey: "token") as? String
        
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
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(teams, forKey: "teams")
        aCoder.encode(token, forKey: "token")
        
    }
    
    public override var description: String {
        var description = "User (\(self.id)):"
        if let name = self.name {
            description += " "
            description += name
            description += ","
        }
        if let email = self.email {
            description += " "
            description += email
            description += ","
        }
        if let username = self.username {
            description += " "
            description += username
            description += ","
        }
        return description
    }
    
}

/**
 
 Returns whether the two users are equal.
 
 - Parameters:
     - lhs: The left-hand side value to compare.
     - rhs: The right-hand side value to compare.
 
 - Returns: `true` if the two values are equal, `false` otherwise.
 
 */

public func ==(lhs: DKUser?, rhs: DKUser?) -> Bool {
    return lhs?.id == rhs?.id
}
