//
//  DMItem+Codable.swift
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

extension DKItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case collectionID           = "collection_id"
        case collectionName         = "collection_name"
        case content
        case createdAt              = "created_at"
        case deletedAt              = "deleted_at"
        case descriptionText        = "description"
        case id
        case isShareable            = "shareable"
        case isURL                  = "is_url"
        case itemsTotalCount        = "items_total_count"
        case latitude
        case link
        case longitude
        case metadata
        case mime
        case name
        case parentID               = "parent_id"
        case parentName             = "parent_name"
        case reactionsTotalCount    = "reactions_total_count"
        case shortURL               = "short_url"
        case size
        case thumbnail
        case typeRaw                = "type"
        case updatedAt              = "updated_at"
        case url
        case thumbnails
        case comments
        case reactions
    }

    public convenience init(from decoder: Decoder) throws {
                
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.collectionID           = try container.decode(Int64.self, forKey: .collectionID) as NSNumber
        self.collectionName         = try container.decodeIfPresent(String.self, forKey: .collectionName)
        self.content                = try container.decodeIfPresent(String.self, forKey: .content)
        self.createdAt              = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.deletedAt              = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        self.descriptionText        = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        self.id                     = try container.decode(Int64.self, forKey: .id) as NSNumber
        self.isShareable            = try container.decodeIfPresent(Bool.self, forKey: .isShareable) as? NSNumber
        self.isURL                  = try container.decodeIfPresent(Bool.self, forKey: .isURL) as? NSNumber
        self.itemsTotalCount        = try container.decodeIfPresent(Int.self, forKey: .itemsTotalCount) as? NSNumber
        self.latitude               = try container.decodeIfPresent(Double.self, forKey: .latitude) as? NSNumber
        self.link                   = try container.decodeIfPresent(URL.self, forKey: .link)
        self.longitude              = try container.decodeIfPresent(Double.self, forKey: .longitude) as? NSNumber
        
        if let usageDictionary = try? container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .metadata) {
            self.metadata = usageDictionary as NSDictionary
        }
        
        self.mime                   = try container.decodeIfPresent(String.self, forKey: .mime)
        self.name                   = try container.decodeIfPresent(String.self, forKey: .name)
        self.parentID               = try container.decodeIfPresent(Int.self, forKey: .parentID) as? NSNumber
        self.parentName             = try container.decodeIfPresent(String.self, forKey: .parentName)
        self.reactionsTotalCount    = try container.decodeIfPresent(Int.self, forKey: .reactionsTotalCount) as? NSNumber
        self.shortURL               = try container.decodeIfPresent(URL.self, forKey: .shortURL)
        self.size                   = try container.decodeIfPresent(Int.self, forKey: .size) as? NSNumber
        self.thumbnail              = try container.decodeIfPresent(URL.self, forKey: .thumbnail)
        self.typeRaw                = try container.decodeIfPresent(String.self, forKey: .typeRaw)
        self.updatedAt              = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.url                    = try container.decodeIfPresent(URL.self, forKey: .url)
        self.thumbnails             = try container.decodeIfPresent(DKThumbnails.self, forKey: .thumbnails)
        self.comments               = try container.decodeIfPresent(Set<DKComment>.self, forKey: .comments)
        self.reactions              = try container.decodeIfPresent(Set<DKReaction>.self, forKey: .reactions)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(collectionID.int64Value, forKey: .collectionID)
        try container.encode(collectionName, forKey: .collectionName)
        try container.encode(content, forKey: .content)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(deletedAt, forKey: .deletedAt)
        try container.encode(descriptionText, forKey: .descriptionText)
        try container.encode(id.int64Value, forKey: .id)
        try container.encode(isShareable?.boolValue, forKey: .isShareable)
        try container.encode(isURL?.boolValue, forKey: .isURL)
        try container.encode(itemsTotalCount?.int32Value, forKey: .itemsTotalCount)
        try container.encode(latitude?.doubleValue, forKey: .latitude)
        try container.encode(link, forKey: .link)
        try container.encode(longitude?.doubleValue, forKey: .longitude)
        // TODO: Figure out a performant way to encode a dictionary (without flattening into Data)
//        try container.encode((metadata as? Dictionary<String, Any>), forKey: .metadata)
        try container.encode(mime, forKey: .mime)
        try container.encode(name, forKey: .name)
        try container.encode(parentID?.int64Value, forKey: .parentID)
        try container.encode(parentName, forKey: .parentName)
        try container.encode(reactionsTotalCount?.int32Value, forKey: .reactionsTotalCount)
        try container.encode(shortURL, forKey: .shortURL)
        try container.encode(size?.int64Value, forKey: .size)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(typeRaw, forKey: .typeRaw)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(thumbnails, forKey: .thumbnails)
        
    }
    
}
