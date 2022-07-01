//
//  DMItem+Codable.swift
//  Pods
//
//  Created by Alex Givens on 7/1/22.
//

import Foundation
import CoreData

extension DMItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case collectionID = "collection_id"
        case collectionName = "collection_name"
        case content
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case descriptionText = "description"
        case id
        case isShareable = "shareable"
        case isURL = "is_url"
        case itemsTotalCount = "items_total_count"
        case latitude
        case longitiude
        case link
        case metadata
        case mime
        case name
        case parentID = "parent_id"
        case parentName = "parent_name"
        case reactionsTotalCount = "reactions_total_count"
        case shortURL = "short_url"
        case size
        case thumbnail
        case typeRaw = "type"
        case updatedAt = "updated_at"
        case url
    }

    public convenience init(from decoder: Decoder) throws {
        
        print("Made it to the decoder")
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.collectionID = try container.decode(Int64.self, forKey: .collectionID)
        self.collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        self.descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.isShareable = try container.decodeIfPresent(Bool.self, forKey: .isShareable) ?? false
        self.isURL = try container.decodeIfPresent(Bool.self, forKey: .isURL) ?? false
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(collectionID, forKey: .collectionID)

    }
    
}
