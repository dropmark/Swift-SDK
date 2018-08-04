//
//  DKPermissions.swift
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
 
 In a collection, the permissions represent what actions the current user can and cannot perform.
 
*/

@objc(DKPermissions)
public class DKPermissions: NSObject, NSCoding {
    
    public var admin: Bool?
    public var edit: Bool?
    public var share: Bool?
    public var leave: Bool?
    public var delete: Bool?
    
    // Init from Alamofire
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any]
        else { return nil }
        
        admin = representation["admin"] as? Bool
        edit = representation["edit"] as? Bool
        share = representation["share"] as? Bool
        leave = representation["leave"] as? Bool
        delete = representation["delete"] as? Bool
        
    }
    
    // Init from NSUserDefaults
    public required init(coder aDecoder: NSCoder) {
        
        admin = aDecoder.decodeObject(forKey: "admin") as? Bool
        edit = aDecoder.decodeObject(forKey: "edit") as? Bool
        share = aDecoder.decodeObject(forKey: "share") as? Bool
        leave = aDecoder.decodeObject(forKey: "leave") as? Bool
        delete = aDecoder.decodeObject(forKey: "delete") as? Bool
        
    }
    
    // Save to NSUserDefaults
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(admin, forKey: "admin")
        aCoder.encode(edit, forKey: "edit")
        aCoder.encode(share, forKey: "share")
        aCoder.encode(leave, forKey: "leave")
        aCoder.encode(delete, forKey: "delete")
        
    }
    
}
