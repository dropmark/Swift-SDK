//
//  DKComment+Codable.swift
//  Pods
//
//  Created by Alex Givens on 7/11/22.
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
        
        self.annotation = try container.decodeIfPresent(URL.self, forKey: .annotation)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        self.collectionID = try container.decodeIfPresent(Int64.self, forKey: .collectionID) as NSNumber?
        self.collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName)
        self.collectionURL = try container.decodeIfPresent(URL.self, forKey: .collectionURL)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.itemID = try container.decodeIfPresent(Int64.self, forKey: .itemID) as? NSNumber
        self.itemName = try container.decodeIfPresent(String.self, forKey: .itemName)
        self.shortURL = try container.decodeIfPresent(URL.self, forKey: .shortURL)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(annotation, forKey: .annotation)
        try container.encode(body, forKey: .body)
        try container.encode(collectionID?.intValue , forKey: .collectionID)
        try container.encode(collectionName, forKey: .collectionName)
        try container.encode(collectionURL, forKey: .collectionURL)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(id, forKey: .id)
        try container.encode(itemID?.intValue, forKey: .itemID)
        try container.encode(itemName, forKey: .itemName)
        try container.encode(shortURL, forKey: .shortURL)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(url, forKey: .url)
        
    }
    
}
