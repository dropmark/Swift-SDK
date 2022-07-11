//
//  DKThumbnails+Codable.swift
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
