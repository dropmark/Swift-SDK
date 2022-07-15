//
//  DKUser+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/15/22.
//
//

import Foundation
import CoreData


extension DKUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKUser> {
        return NSFetchRequest<DKUser>(entityName: "DKUser")
    }

    @NSManaged public var avatar: URL?
    @NSManaged public var billingEmail: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var customDomain: URL?
    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var planIsActive: Bool
    @NSManaged public var planQuantity: Int64
    @NSManaged public var planRaw: String?
    @NSManaged public var showLabels: Bool
    @NSManaged public var sortByRaw: String?
    @NSManaged public var sortOrderRaw: String?
    @NSManaged public var statusRaw: String?
    @NSManaged public var storageQuota: NSNumber?
    @NSManaged public var storageUsed: NSNumber?
    @NSManaged public var token: String?
    @NSManaged public var username: String?
    @NSManaged public var viewModeRaw: String?

}

extension DKUser : Identifiable {

}
