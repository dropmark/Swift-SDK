//
//  DKTeam+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/18/22.
//
//

import Foundation
import CoreData


extension DKTeam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKTeam> {
        return NSFetchRequest<DKTeam>(entityName: "DKTeam")
    }

    @NSManaged public var avatar: URL?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var username: String?
    @NSManaged public var customDomain: URL?
    @NSManaged public var sortByRaw: String?
    @NSManaged public var sortOrderRaw: String?
    @NSManaged public var statusRaw: String?
    @NSManaged public var viewModeRaw: String?
    @NSManaged public var showLabels: Bool
    @NSManaged public var planRaw: String?
    @NSManaged public var planIsActive: Bool
    @NSManaged public var planQuantity: Int64
    @NSManaged public var billingEmail: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var feedKey: String?
    @NSManaged public var storageQuota: Int64
    @NSManaged public var storageUsed: Int64
    @NSManaged public var userKindRaw: String?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension DKTeam {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: DKUser)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: DKUser)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

extension DKTeam : Identifiable {

}
