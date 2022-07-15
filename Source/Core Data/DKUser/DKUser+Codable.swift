//
//  DKUser+Codable.swift
//  Pods
//
//  Created by Alex Givens on 7/15/22.
//

import Foundation
import CoreData

extension DKUser: Codable {
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case userAvatar     = "user_avatar" // Alternative avatar field
        case billingEmail   = "billing_email"
        case createdAt      = "created_at"
        case customDomain   = "custom_domain"
        case email
        case id
        case name
        case planIsActive   = "plan_active"
        case planQuantity   = "plan_quantity"
        case planRaw        = "plan"
        case showLabels     = "labels"
        case sortByRaw      = "sort_by"
        case sortOrderRaw   = "sort_order"
        case statusRaw      = "status"
        case usage // Get the usage dictionary
        case storageQuota   = "quota"
        case storageUsed    = "used"
        case username
        case viewModeRaw    = "view_mode"
    }
    
    public convenience init(from decoder: Decoder) throws {
                
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let avatarString = try? container.decodeIfPresent(String.self, forKey: .avatar)
        {
            self.avatar = URL(string: avatarString)
        } else if let avatarString = try? container.decodeIfPresent(String.self, forKey: .userAvatar) {
            self.avatar = URL(string: avatarString)
        }
        
        self.billingEmail = try container.decodeIfPresent(String.self, forKey: .billingEmail)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.customDomain = try container.decodeIfPresent(URL.self, forKey: .customDomain)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.planIsActive = try container.decodeIfPresent(Bool.self, forKey: .planIsActive) ?? false
        self.planQuantity = try container.decodeIfPresent(Int64.self, forKey: .planQuantity) ?? 0
        self.planRaw = try container.decodeIfPresent(String.self, forKey: .planRaw)
        self.showLabels = try container.decodeIfPresent(Bool.self, forKey: .showLabels) ?? true
        self.sortByRaw = try container.decodeIfPresent(String.self, forKey: .sortByRaw)
        self.sortOrderRaw = try container.decodeIfPresent(String.self, forKey: .sortOrderRaw)
        self.statusRaw = try container.decodeIfPresent(String.self, forKey: .statusRaw)
        
        if let usageDictionary = try? container.decodeIfPresent(Dictionary<String, Any>.self, forKey: .usage) {
            if let storageUsed = usageDictionary["used"] as? NSNumber {
                self.storageUsed = storageUsed
            }
            if let storageQuota = usageDictionary["quota"] as? NSNumber {
                self.storageQuota = storageQuota
            }
        }
        
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.viewModeRaw = try container.decodeIfPresent(String.self, forKey: .viewModeRaw)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        
        
    }
    
}
