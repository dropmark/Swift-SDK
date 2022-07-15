//
//  DKUser+CoreDataClass.swift
//  Pods
//
//  Created by Alex Givens on 7/14/22.
//
//

import Foundation
import CoreData

@objc(DKUser)
public final class DKUser: NSManagedObject {
    
    /// A user's ability to act on the Dropmark platform
    public enum Status: String, CaseIterable {

        /// A user retains the ability to act within Dropmark
        case active

        /// A user cannot act on Dropmark
        case inactive

    }
    
    var plan: DKPlan? {
        guard
            let planRaw = self.planRaw,
            let plan = DKPlan(rawValue: planRaw)
        else { return nil }
        return plan
    }
    
    var sortBy: DKSortBy? {
        guard
            let sortByRaw = self.sortByRaw,
            let sortBy = DKSortBy(rawValue: sortByRaw)
        else { return nil }
        return sortBy
    }
    
    var sortOrder: DKSortOrder? {
        guard
            let sortOrderRaw = self.sortOrderRaw,
            let sortOrder = DKSortOrder(rawValue: sortOrderRaw)
        else { return nil }
        return sortOrder
    }
    
    var status: Status? {
        guard
            let statusRaw = self.statusRaw,
            let status = Status(rawValue: statusRaw)
        else { return nil }
        return status
    }
    
    // MARK: Utility

    public override var description: String {
        var description = "User (\(self.id)): \(self.name ?? ""),"
        if let email = self.email {
            description += " \(email),"
        }
        if let username = self.username {
            description += " \(username)"
        }
        return description
    }

}
