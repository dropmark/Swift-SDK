//
//  DKThumbnails+Codable.swift
//  Pods
//
//  Created by Alex Givens on 7/8/22.
//

import Foundation
import CoreData

extension DKThumbnails: Codable {
    
    enum CodingKeys: String, CodingKey {
        case mini
        case small
        case cropped
        case uncropped
        case large
        case croppedAnimated    = "cropped_animated"
        case uncroppedAnimated  = "uncropped_animated"
    }
    
    public convenience init(from decoder: Decoder) throws {
                
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.mini               = try container.decodeIfPresent(URL.self, forKey: .mini)
        self.small              = try container.decodeIfPresent(URL.self, forKey: .small)
        self.cropped            = try container.decodeIfPresent(URL.self, forKey: .cropped)
        self.uncropped          = try container.decodeIfPresent(URL.self, forKey: .uncropped)
        self.large              = try container.decodeIfPresent(URL.self, forKey: .large)
        self.croppedAnimated    = try container.decodeIfPresent(URL.self, forKey: .croppedAnimated)
        self.uncroppedAnimated  = try container.decodeIfPresent(URL.self, forKey: .uncroppedAnimated)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mini, forKey: .mini)
        try container.encode(small, forKey: .small)
        try container.encode(cropped, forKey: .cropped)
        try container.encode(uncropped, forKey: .uncropped)
        try container.encode(large, forKey: .large)
        try container.encode(croppedAnimated, forKey: .croppedAnimated)
        try container.encode(uncroppedAnimated, forKey: .uncroppedAnimated)
        
    }
    
}
