//
//  DKSortBy.swift
//  Pods
//
//  Created by Alex Givens on 7/15/22.
//

import Foundation

/// Sorting methods for child items. Note: This variable is maintained by the Dropmark API, and may differ from local sorting methods.
public enum DKSortBy: String {
    
    /// Sort by the date the collection was created
    case createdAt = "created_at"
    
    /// Sort by the date the collection was last updated
    case updatedAt = "updated_at"
    
    /// Sort alphabetically by name
    case name
    
    /// Sort by the `kind` type
    case `type`
    
    /// Sort by the number of items contained by the collection
    case size
    
    /// Sort by the number of reactions contained in the collection
    case reactions
    
    /// Manual sorting
    case manual = "null"
    
}
