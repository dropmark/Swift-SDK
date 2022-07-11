//
//  DKThumbnails+CoreDataProperties.swift
//  Pods
//
//  Created by Alex Givens on 7/9/22.
//
//

import Foundation
import CoreData


extension DKThumbnails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKThumbnails> {
        return NSFetchRequest<DKThumbnails>(entityName: "DKThumbnails")
    }

    @NSManaged public var cropped: URL?
    @NSManaged public var croppedAnimated: URL?
    @NSManaged public var large: URL?
    @NSManaged public var mini: URL?
    @NSManaged public var small: URL?
    @NSManaged public var uncropped: URL?
    @NSManaged public var uncroppedAnimated: URL?

}

extension DKThumbnails : Identifiable {

}
