//
//  DKItem+CoreDataClass.swift
//  Pods
//
//  Created by Alex Givens on 7/5/22.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(DKItem)
public final class DKItem: NSManagedObject {
    
    /// The effective file path for an item on Dropmark's servers
    public var directory: DKDirectory {
        return DKDirectory(collectionID: collectionID, stackID: parentID)
    }
    
    public var location: CLLocation? {
        guard
            let latitude = self.latitude?.doubleValue,
            let longitude = self.longitude?.doubleValue
        else { return nil }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    public var type: DKItemType {
        guard
            let typeRaw = self.typeRaw,
            let type = DKItemType(rawValue: typeRaw)
        else { return .other }
        return type
    }

}
