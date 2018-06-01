//
//  Team.swift
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

@objc(Team)
public final class Team: NSObject, NSCoding, ResponseObjectSerializable, ResponseListSerializable {
    
    public enum Status: String {
        case active
        case inactive
    }
    
    public enum Plan: String {
        case free
        case pro
        case proBeta = "pro_beta"
        case proMonthly = "pro_monthly"
        case team
    }
    
    public enum UserKind: String {
        case manager
        case user
    }
    
    public var id : NSNumber!
    public var name : String!
    public var email : String?
    public var username : String?
    public var customDomain : String?
    public var sortBy : String?
    public var sortOrder : String?
    public var viewMode : String?
    public var labels : Bool?
    public var plan : Plan = .free
    public var planIsActive : Bool?
    public var planQuantity : NSNumber?
    public var billingEmail : String?
    public var status : Status = .active
    public var createdAt : Date?
    public var feedKey : String?
    public var usage : [String: AnyObject]?
    public var userKind : UserKind?
    public var users: [User]?
    public var avatar: String?
    
    public init?(id: NSNumber) {
        self.id = id
    }
    
    // Init from Alamofire
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
        if let planString = representation["user_plan"] as? String, let plan = Plan(rawValue: planString) {
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
        if let usersRepresentation = representation["users"] as? [AnyObject] {
            users = usersRepresentation.map({ User(response:response, representation: $0)! })
        }
        avatar = representation["avatar"] as? String
        if avatar == nil {
            avatar = representation["user_avatar"] as? String
        }
    }
    
    // Init from NSUserDefaults
    public required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as! NSNumber
        name = aDecoder.decodeObject(forKey: "name") as! String
        email = aDecoder.decodeObject(forKey: "email") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        customDomain = aDecoder.decodeObject(forKey: "custom_domain") as? String
        sortBy = aDecoder.decodeObject(forKey: "sort_by") as? String
        sortOrder = aDecoder.decodeObject(forKey: "sort_order") as? String
        viewMode = aDecoder.decodeObject(forKey: "view_mode") as? String
        labels = aDecoder.decodeObject(forKey: "labels") as? Bool
        if let planString = aDecoder.decodeObject(forKey: "plan") as? String {
            plan = Plan(rawValue: planString) ?? .free
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
        users = aDecoder.decodeObject(forKey: "users") as? [User]
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String
    }
    
    // Save to NSUserDefaults
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

// MARK: Equatable

public func ==(lhs: Team, rhs: Team) -> Bool {
    return lhs.id == rhs.id
}

public func !=(lhs: Team, rhs: Team) -> Bool {
    return lhs.id != rhs.id
}

public func ==(lhs: Team?, rhs: Team) -> Bool {
    return lhs?.id == rhs.id
}

public func ==(lhs: Team, rhs: Team?) -> Bool {
    return lhs.id == rhs?.id
}

func ==(lhs: Team?, rhs: Team?) -> Bool {
    return lhs?.id == rhs?.id
}
