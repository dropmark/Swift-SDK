//
//  DKTag+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/11/22.
//
//

import Foundation
import CoreData


extension DKTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKTag> {
        return NSFetchRequest<DKTag>(entityName: "DKTag")
    }

    @NSManaged public var itemsTotalCount: NSNumber?
    @NSManaged public var name: String?

}

extension DKTag : Identifiable {

}
