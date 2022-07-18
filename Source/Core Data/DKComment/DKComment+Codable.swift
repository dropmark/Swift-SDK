//
//  DKComment+Codable.swift
//
//  Copyright © 2022 Oak, LLC (https://oak.is)
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
import CoreData

extension DKComment: Codable {
    
    enum CodingKeys: String, CodingKey {
        case annotation
        case body
        case collectionID   = "collection_id"
        case collectionName = "collection_name"
        case collectionURL  = "collection_url"
        case createdAt      = "created_at"
        case id
        case itemID         = "item_id"
        case itemName       = "item_name"
        case shortURL       = "short_url"
        case updatedAt      = "updated_at"
        case url
    }
    
    public convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.annotation     = try container.decodeIfPresent(URL.self, forKey: .annotation)
        self.body           = try container.decodeIfPresent(String.self, forKey: .body)
        self.collectionID   = try container.decodeIfPresent(Int64.self, forKey: .collectionID) as NSNumber?
        self.collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName)
        self.collectionURL  = try container.decodeIfPresent(URL.self, forKey: .collectionURL)
        self.createdAt      = try container.decode(Date.self, forKey: .createdAt)
        self.id             = try container.decode(Int64.self, forKey: .id) as NSNumber
        self.itemID         = try container.decodeIfPresent(Int64.self, forKey: .itemID) as? NSNumber
        self.itemName       = try container.decodeIfPresent(String.self, forKey: .itemName)
        self.shortURL       = try container.decodeIfPresent(URL.self, forKey: .shortURL)
        self.updatedAt      = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.url            = try container.decodeIfPresent(URL.self, forKey: .url)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(annotation, forKey: .annotation)
        try container.encode(body, forKey: .body)
        try container.encode(collectionID?.intValue , forKey: .collectionID)
        try container.encode(collectionName, forKey: .collectionName)
        try container.encode(collectionURL, forKey: .collectionURL)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(id.int64Value, forKey: .id)
        try container.encode(itemID?.int64Value, forKey: .itemID)
        try container.encode(itemName, forKey: .itemName)
        try container.encode(shortURL, forKey: .shortURL)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(url, forKey: .url)
        
    }
    
}
