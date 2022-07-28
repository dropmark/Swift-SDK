//
//  DKUser+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/28/22.
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
    @NSManaged public var id: NSNumber // Altered from generated subclass
    @NSManaged public var name: String // Altered from generated subclass
    @NSManaged public var planIsActive: NSNumber?
    @NSManaged public var planQuantity: NSNumber?
    @NSManaged public var planRaw: String?
    @NSManaged public var showLabels: NSNumber?
    @NSManaged public var sortByRaw: String?
    @NSManaged public var sortOrderRaw: String?
    @NSManaged public var statusRaw: String?
    @NSManaged public var storageQuota: NSNumber?
    @NSManaged public var storageUsed: NSNumber?
    @NSManaged public var username: String?
    @NSManaged public var viewModeRaw: String?
    @NSManaged public var teams: Set<DKTeam>? // Altered from generated subclass

}

// MARK: Generated accessors for teams
extension DKUser {

    @objc(addTeamsObject:)
    @NSManaged public func addToTeams(_ value: DKTeam)

    @objc(removeTeamsObject:)
    @NSManaged public func removeFromTeams(_ value: DKTeam)

    @objc(addTeams:)
    @NSManaged public func addToTeams(_ values: NSSet)

    @objc(removeTeams:)
    @NSManaged public func removeFromTeams(_ values: NSSet)

}

extension DKUser : Identifiable {

}
