//
//  DKDirectory.swift
//  Pods
//
//  Created by Alex Givens on 11/22/21.
//

import Foundation

public enum DKDirectoryError: Error {
    case invalidDirectory
}

/// Encaspulates (and validates) a directory destination
public struct DKDirectory {

    /// The unique identifier of the destination collection
    public var collectionID: NSNumber
    
    /// The unique identifier of the destination stack, if available
    public var stackID: NSNumber?
    
    /**
 
     Create a destination aimed at a specific collection and stack
 
     - Parameters:
        - collection: The destination collection
        - stack: The destination stack
     
     - Throws: Returns an error if the provided stack item is not a `DKItemType.stack`
     
     */
    
    public init(collection: DKCollection, stack: DKItem? = nil) throws {
        
        self.collectionID = collection.id
        
        if let stack = stack {
            guard stack.type == .stack else {
                throw DKDirectoryError.invalidDirectory
            }
            self.stackID = stack.id
        }
        
    }
    
    /**
     
     Create a destination aimed at a specific collection and stack
     
     - Parameters:
        - collectionID: The unique identifier of the destination collection
        - stackID: The unique identifier of the destination stack
     
     */
    
    public init(collectionID: NSNumber, stackID: NSNumber? = nil) {
        
        self.collectionID = collectionID
        self.stackID = stackID
        
    }
    
}

public func ==(lhs: DKDirectory?, rhs: DKDirectory?) -> Bool {
    guard
        let lhsCollectionID = lhs?.collectionID,
        let rhsCollectionID = rhs?.collectionID,
        lhsCollectionID == rhsCollectionID
    else { return false }
    if
        let lhsStackID = lhs?.stackID,
        let rhsStackID = rhs?.stackID,
        lhsStackID == rhsStackID
    {
        return true
    } else if (lhs?.stackID == nil) && (rhs?.stackID == nil) {
        return true
    }
    return false
}
