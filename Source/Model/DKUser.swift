//
//  DKUser.swift
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

/**
 
 Represents a user on Dropmark. Can be the current user, collaborators, or users external to your team.
 
    - Note: Only when a user is retrieved from the `/auth` API endpoint will a `token` be returned
 
 */
@objc(DKUser)
public final class DKUser: NSObject, NSCoding, DKResponseObjectSerializable, DKResponseListSerializable, DKAccount {
    
    public struct Key {
        public static let id = "id"
        public static let name = "name"
        public static let email = "email"
        public static let username = "username"
        public static let customDomain = "custom_domain"
        public static let sortBy = "sort_by"
        public static let sortOrder = "sort_order"
        public static let viewMode = "view_mode"
        public static let labels = "labels"
        public static let plan = "plan"
        public static let planActive = "plan_active"
        public static let planQuantity = "plan_quantity"
        public static let storageQuota = "storageQuota"
        public static let storageUsed = "storageUsed"
        public static let billingEmail = "billing_email"
        public static let kind = "kind"
        public static let status = "status"
        public static let createdAt = "created_at"
        public static let avatar = "avatar"
        public static let stripeID = "stripe_id"
        public static let teams = "teams"
        public static let metadata = "metadata"
        public static let token = "token"
    }
    
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
    @objc public var id : NSNumber
    
    /// The name of the user
    public var name : String
    
    /// The primary email of the user
    @objc public var email : String?
    
    /// The unique username of the user
    @objc public var username : String?
    
    
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
    
    /// The total amount of storage available for the current user (in bytes)
    public var storageQuota: NSNumber = 0
    
    /// The amount of storage used by the current user (in bytes)
    public var storageUsed: NSNumber = 0
    
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
    
    /// If the user starts a  subscription on the web, this field will contain their unique ID for Stripe
    public var stripeID: String?
    
    /// A list of all teams of which the user is a member.
    public var teams: [DKTeam]?
    
    /// Contains a range of other data associated with the user
    public var metadata: [String: AnyObject]?
    
    /// Used to authenticate requests on behalf of the user. **Note**: A token value only returns from the `/auth` API endpoint
    @objc public var token: String?
    
    /**
     
     Initialize a local instance with an ID
     
     - Parameters:
        - id: The unique ID number to identify this user
     
     */
    
    public init(id: NSNumber, name: String = "") {
        self.id = id
        self.name = name
    }
    
    // MARK: DKResponseObjectSerializable
    
    /**
     
     Serializes a new instance from the provided network response and key-value representation. The representation is validated for the required parameters, then fills in optional parameters as necessary.
     
     - Parameters:
        - response: A network response assocated with serialization
        - representation: A key-value object representing parameters and child objects.
     
     */
    
    @objc public required init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation[Key.id] as? NSNumber,
            let name = representation[Key.name] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        email = representation[Key.email] as? String
        username = representation[Key.username] as? String
        customDomain = representation[Key.customDomain] as? String
        sortBy = representation[Key.sortBy] as? String
        sortOrder = representation[Key.sortOrder] as? String
        viewMode = representation[Key.viewMode] as? String
        labels = representation[Key.labels] as? Bool
        
        if let planString = representation[Key.plan] as? String, let plan = DKPlan(rawValue: planString) {
            self.plan = plan
        }
        
        planIsActive = representation[Key.planActive] as? Bool
        planQuantity = representation[Key.planQuantity] as? NSNumber
        
        if let usage = representation["usage"] as? [String: Any] {
            
            if let storageQuota = usage["quota"] as? NSNumber {
                self.storageQuota = storageQuota
            }
            
            if let storageUsed = usage["used"] as? NSNumber {
                self.storageUsed = storageUsed
            }
            
        }
        
        billingEmail = representation[Key.billingEmail] as? String
        
        if let kindString = representation[Key.kind] as? String, let kind = Kind(rawValue: kindString) {
            self.kind = kind
        }
        
        if let statusString = representation[Key.status] as? String, let status = Status(rawValue: statusString) {
            self.status = status
        }
        
        if let createdAtString = representation[Key.createdAt] as? String {
            createdAt = DKDateFormatter().date(from: createdAtString)
        }
        
        if let avatarString = representation[Key.avatar] as? String {
            avatar = URL(string: avatarString)
        } else if let avatarString = representation["user_avatar"] as? String {
            avatar = URL(string: avatarString)
        }
        
        if let stripeID = representation[Key.stripeID] as? String {
            self.stripeID = stripeID
        }
        
        if let teamRepresentations = representation[Key.teams] as? [Any] {
            teams = teamRepresentations.compactMap{ DKTeam(response: response, representation: $0) }
        }
        
        token = representation[Key.token] as? String

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
            let id = aDecoder.decodeObject(forKey: Key.id) as? NSNumber,
            let name = aDecoder.decodeObject(forKey: Key.name) as? String
        else { return nil}
        
        self.id = id
        self.name = name
        email = aDecoder.decodeObject(forKey: Key.email) as? String
        username = aDecoder.decodeObject(forKey: Key.username) as? String
        customDomain = aDecoder.decodeObject(forKey: Key.customDomain) as? String
        sortBy = aDecoder.decodeObject(forKey: Key.sortBy) as? String
        sortOrder = aDecoder.decodeObject(forKey: Key.sortOrder) as? String
        viewMode = aDecoder.decodeObject(forKey: Key.viewMode) as? String
        labels = aDecoder.decodeObject(forKey: Key.labels) as? Bool
        
        if
            let planString = aDecoder.decodeObject(forKey: Key.plan) as? String,
            let plan = DKPlan(rawValue: planString)
        {
            self.plan = plan
        }
        
        planIsActive = aDecoder.decodeObject(forKey: Key.planActive) as? Bool
        planQuantity = aDecoder.decodeObject(forKey: Key.planQuantity) as? NSNumber
        
        if let storageQuota = aDecoder.decodeObject(forKey: Key.storageQuota) as? NSNumber {
            self.storageQuota = storageQuota
        }
        
        if let storageUsed = aDecoder.decodeObject(forKey: Key.storageUsed) as? NSNumber {
            self.storageUsed = storageUsed
        }
        
        billingEmail = aDecoder.decodeObject(forKey: Key.billingEmail) as? String
        
        if let statusString = aDecoder.decodeObject(forKey: Key.status) as? String, let status = Status(rawValue: statusString) {
            self.status = status
        }
        
        createdAt = aDecoder.decodeObject(forKey: Key.createdAt) as? Date
        avatar = aDecoder.decodeObject(forKey: Key.avatar) as? URL
        stripeID = aDecoder.decodeObject(forKey: Key.stripeID) as? String
        teams = aDecoder.decodeObject(forKey: Key.teams) as? [DKTeam]
        metadata = aDecoder.decodeObject(forKey: Key.metadata) as? [String: AnyObject]
        token = aDecoder.decodeObject(forKey: Key.token) as? String
        
    }
    
    /**
     
     Encodes the receiver using a given archiver.
     
     - Parameters:
        - encoder: An archiver object.
     
     */
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: Key.id)
        aCoder.encode(name, forKey: Key.name)
        aCoder.encode(email, forKey: Key.email)
        aCoder.encode(username, forKey: Key.username)
        aCoder.encode(customDomain, forKey: Key.customDomain)
        aCoder.encode(sortBy, forKey: Key.sortBy)
        aCoder.encode(sortOrder, forKey: Key.sortOrder)
        aCoder.encode(viewMode, forKey: Key.viewMode)
        aCoder.encode(labels, forKey: Key.labels)
        aCoder.encode(plan.rawValue, forKey: Key.plan)
        aCoder.encode(planIsActive, forKey: Key.planActive)
        aCoder.encode(planQuantity, forKey: Key.planQuantity)
        aCoder.encode(storageQuota, forKey: Key.storageQuota)
        aCoder.encode(storageUsed, forKey: Key.storageUsed)
        aCoder.encode(billingEmail, forKey: Key.billingEmail)
        aCoder.encode(status.rawValue, forKey: Key.status)
        aCoder.encode(createdAt, forKey: Key.createdAt)
        aCoder.encode(avatar, forKey: Key.avatar)
        aCoder.encode(stripeID, forKey: Key.stripeID)
        aCoder.encode(teams, forKey: Key.teams)
        aCoder.encode(metadata, forKey: Key.metadata)
        aCoder.encode(token, forKey: Key.token)
        
    }
    
    // MARK: Utility
    
    public override var description: String {
        var description = "User (\(self.id)): \(self.name),"
        if let email = self.email {
            description += " \(email),"
        }
        if let username = self.username {
            description += " \(username)"
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
