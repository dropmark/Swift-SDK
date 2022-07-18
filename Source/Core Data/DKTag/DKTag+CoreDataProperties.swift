//
//  DKTag+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/18/22.
//
//

import Foundation
import CoreData


extension DKTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKTag> {
        return NSFetchRequest<DKTag>(entityName: "DKTag")
    }

    @NSManaged public var itemsTotalCount: Int32
    @NSManaged public var name: String?
    @NSManaged public var item: DKItem?

}

extension DKTag : Identifiable {

}
