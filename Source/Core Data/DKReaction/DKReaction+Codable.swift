//
//  DKReaction+Codable.swift
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

extension DKReaction: Codable {
    
    enum CodingKeys: String, CodingKey {
        case collectionID   = "collection_id"
        case collectionName = "collection_name"
        case createdAt      = "created_at"
        case id
        case itemID         = "item_id"
        case itemName       = "item_name"
        case updatedAt      = "updated_at"
    }
    
    public convenience init(from decoder: Decoder) throws {
                
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.collectionID   = try container.decodeIfPresent(Int64.self, forKey: .collectionID) as? NSNumber
        self.collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName)
        self.createdAt      = try container.decode(Date.self, forKey: .createdAt)
        self.id             = try container.decode(Int64.self, forKey: .id)
        self.itemID         = try container.decode(Int64.self, forKey: .itemID)
        self.itemName       = try container.decodeIfPresent(String.self, forKey: .itemName)
        self.updatedAt      = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(collectionID?.intValue, forKey: .collectionID)
        try container.encode(collectionName, forKey: .collectionName)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(id, forKey: .id)
        try container.encode(itemID, forKey: .itemID)
        try container.encode(itemName, forKey: .itemName)
        try container.encode(updatedAt, forKey: .updatedAt)
        
    }
    
}
