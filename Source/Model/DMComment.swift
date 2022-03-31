//
//  DMComment.swift
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

/// Comments can be added to individual items.
public struct DMComment: Codable {
    
    /// The unique identifier of the comment
    public var id: Int
    
    /// The unique identifier for the associated item
    public var itemID: Int?
    
    /// The name of the associated item
    public var itemName: String?
    
    /// The unique identifier of the parent collection
    public var collectionID: Int?
    
    /// The name of the parent collection
    public var collectionName: String?
    
    /// The Dropmark link of the parent collection
    public var collectionURL: URL?
    
    /// The body text of the comment. This string may contain Markdown-formatted text, including references to images.
    public var body: String
    
    /// The date the comment was created
    public var createdAt: Date
    
    /// The date the the comment was last updated
    public var updatedAt: Date?
    
    
    public var annotation: String?
    
    
    public var url: URL?
    
    
    public var shortURL: URL?
    
    // The creator of the comment
    public var user: DKUser?
    
    public enum CodingKeys: String, CodingKey {
        case id
        case itemID = "item_id"
        case itemName = "item_name"
        case collectionID = "collection_id"
        case collectionName = "collection_name"
        case collectionURL = "collection_url"
        case body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case annotation
        case url
        case shortURL = "short_url"
        case user
    }
    
}

/**
 
 Returns whether the two comments are equal.
 
 - Parameters:
     - lhs: The left-hand side value to compare.
     - rhs: The right-hand side value to compare.
 
 - Returns: `true` if the two values are equal, `false` otherwise.
 
 */

public func ==(lhs: DMComment?, rhs: DMComment?) -> Bool {
    return lhs?.id == rhs?.id
}
