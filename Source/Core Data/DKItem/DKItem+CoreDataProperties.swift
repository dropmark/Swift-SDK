//
//  DKItem+CoreDataProperties.swift
//
//  Copyright © 2022 Oak, LLC (https://oak.is)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import CoreData


extension DKItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKItem> {
        return NSFetchRequest<DKItem>(entityName: "DKItem")
    }

    @NSManaged public var collectionID: Int64
    @NSManaged public var collectionName: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var deletedAt: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int64
    @NSManaged public var isShareable: Bool
    @NSManaged public var isURL: Bool
    @NSManaged public var itemsTotalCount: NSNumber?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var link: URL?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var metadata: NSDictionary?
    @NSManaged public var mime: String?
    @NSManaged public var name: String?
    @NSManaged public var parentID: NSNumber?
    @NSManaged public var parentName: String?
    @NSManaged public var reactionsTotalCount: NSNumber?
    @NSManaged public var shortURL: URL?
    @NSManaged public var size: NSNumber?
    @NSManaged public var thumbnail: URL?
    @NSManaged public var typeRaw: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: URL?
    @NSManaged public var thumbnails: DKThumbnails?

}

extension DKItem : Identifiable {

}
