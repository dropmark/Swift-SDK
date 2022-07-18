//
//  DKCollection+CoreDataClass.swift
//  Pods
//
//  Created by Alex Givens on 7/13/22.
//
//

import Foundation
import CoreData

@objc(DKCollection)
public final class DKCollection: NSManagedObject {
    
    /// Privacy of a collection (and it's items)
    public enum Privacy : String, CaseIterable {

        /// A collection (and it's items) is only accessible by the owner and team members
        case `private`

        /// A collection (and it's items) is available through a direct link, but is not indexed for public search
        case `public`

        /// A collection (and it's items) is publicly available and indexed for search
        case global

    }
    
    /// Different styles of presentation of items, as maintained by the Dropmark API
    public enum ViewMode : String {

        /// Render items as a grid of tiles
        case tile

        /// Render items as a shelf
        case shelf

        /// Render items in a mason-style flow layout
        case flow

        /// Render items in a vertical list
        case list

    }

    public var privacy: Privacy? {
        guard
            let rawValue = self.privacyRaw,
            let privacy = Privacy(rawValue: rawValue)
        else { return nil }
        return privacy
    }
    
    public var sortBy: DKSortBy? {
        guard
            let rawValue = self.sortByRaw,
            let sortBy = DKSortBy(rawValue: rawValue)
        else { return nil }
        return sortBy
    }
    
    public var sortOrder: DKSortOrder? {
        guard
            let rawValue = self.sortOrderRaw,
            let sortOrder = DKSortOrder(rawValue: rawValue)
        else { return nil }
        return sortOrder
    }
    
    public var viewMode: ViewMode? {
        guard
            let rawValue = self.viewModeRaw,
            let viewMode = ViewMode(rawValue: rawValue)
        else { return nil }
        return viewMode
    }
    
}
