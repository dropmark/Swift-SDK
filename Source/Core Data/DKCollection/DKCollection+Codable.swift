//
//  DKCollection+Codable.swift
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

extension DKCollection: Codable {
    
    enum CodingKeys: String, CodingKey {
        case createdAt          = "created_at"
        case customDomain       = "custom_domain"
        case descriptionText    = "description"
        case id
        case isArchived         = "archived"
        case isHighlighted      = "highlighted"
        case itemsTotalCount    = "items_total_count"
        case kindRaw            = "type"
        case lastAccessedAt     = "last_accessed_at"
        case name
        case shortURL           = "short_url"
        case showLabels         = "labels"
        case sort
        case sortByRaw          = "sort_by"
        case sortOrderRaw       = "sort_order"
        case thumbnail
        case updatedAt          = "updated_at"
        case url
        case usersTotalCount    = "users_total_count"
        case viewModeRaw        = "view_mode"
    }
    
    public convenience init(from decoder: Decoder) throws {
                
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.createdAt          = try container.decode(Date.self, forKey: .createdAt)
        self.customDomain       = try container.decodeIfPresent(URL.self, forKey: .customDomain)
        self.descriptionText    = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        self.id                 = try container.decode(Int64.self, forKey: .id)
        self.isArchived         = try container.decodeIfPresent(Bool.self, forKey: .isArchived) ?? false
        self.isHighlighted      = try container.decodeIfPresent(Bool.self, forKey: .isHighlighted) ?? false
        self.itemsTotalCount    = try container.decodeIfPresent(Int32.self, forKey: .itemsTotalCount) as? NSNumber
        self.kindRaw            = try container.decodeIfPresent(String.self, forKey: .kindRaw)
        self.lastAccessedAt     = try container.decodeIfPresent(Date.self, forKey: .lastAccessedAt)
        self.name               = try container.decode(String.self, forKey: .name)
        self.shortURL           = try container.decode(URL.self, forKey: .shortURL)
        self.showLabels         = try container.decodeIfPresent(Bool.self, forKey: .showLabels) ?? true
        self.sort               = try container.decodeIfPresent(Int32.self, forKey: .sort) as? NSNumber
        self.sortByRaw          = try container.decodeIfPresent(String.self, forKey: .sortByRaw)
        self.sortOrderRaw       = try container.decodeIfPresent(String.self, forKey: .sortOrderRaw)
        self.thumbnail          = try container.decodeIfPresent(URL.self, forKey: .thumbnail)
        self.updatedAt          = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.url                = try container.decode(URL.self, forKey: .url)
        self.usersTotalCount    = try container.decodeIfPresent(Int32.self, forKey: .usersTotalCount) ?? 0
        self.viewModeRaw        = try container.decodeIfPresent(String.self, forKey: .viewModeRaw)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(customDomain, forKey: .customDomain)
        try container.encode(descriptionText, forKey: .descriptionText)
        try container.encode(id, forKey: .id)
        try container.encode(isArchived, forKey: .isArchived)
        try container.encode(isHighlighted, forKey: .isHighlighted)
        try container.encode(itemsTotalCount?.int32Value, forKey: .itemsTotalCount)
        try container.encode(kindRaw, forKey: .kindRaw)
        try container.encode(lastAccessedAt, forKey: .lastAccessedAt)
        try container.encode(name, forKey: .name)
        try container.encode(shortURL, forKey: .shortURL)
        try container.encode(showLabels, forKey: .showLabels)
        try container.encode(sort?.int32Value, forKey: .sort)
        try container.encode(sortByRaw, forKey: .sortByRaw)
        try container.encode(sortOrderRaw, forKey: .sortOrderRaw)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(url, forKey: .url)
        try container.encode(usersTotalCount, forKey: .usersTotalCount)
        try container.encode(viewModeRaw, forKey: .viewModeRaw)
        
    }
    
}

