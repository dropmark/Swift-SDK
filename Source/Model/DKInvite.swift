//
//  DKInvite.swift
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

public final class DKInvite: NSObject, DKResponseObjectSerializable, DKResponseListSerializable {
    
    public var id : NSNumber!
    public var name : String!
    public var descriptionText : String?
    public var url : String!
    public var shortURL : String!
    public var createdAt : Date!
    public var updatedAt : Date?
    public var thumbnail : String?
    public var thumbnails : DKThumbnails?
    public var user: DKUser?
    
    // Init from network response
    public required init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? NSNumber,
            let name = representation["name"] as? String,
            let url = representation["url"] as? String,
            let shortURL = representation["short_url"] as? String,
            let createdAtString = representation["created_at"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        thumbnail = representation["thumbnail"] as? String
        
        if let thumbnailsRepresentation = representation["thumbnails"]  {
            thumbnails = DKThumbnails(response: response, representation: thumbnailsRepresentation)
        }
        
        descriptionText = representation["description"] as? String
        createdAt = createdAtString.date
        
        if let updatedAtString = representation["updated_at"] as? String {
            updatedAt = updatedAtString.date
        }
        
        if let userID = representation["user_id"] as? NSNumber, let user = DKUser(id: userID) {
            user.name = representation["user_name"] as? String
            user.username = representation["username"] as? String
            user.email = representation["user_email"] as? String
            user.avatar = representation["user_avatar"] as? String
            self.user = user
        }
        
        self.url = url
        self.shortURL = shortURL
        
    }
    
}
