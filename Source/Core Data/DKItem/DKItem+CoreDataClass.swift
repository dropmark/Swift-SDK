//
//  DKItem+CoreDataClass.swift
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
import CoreLocation

@objc(DKItem)
public final class DKItem: NSManagedObject {
    
    /// The effective file path for an item on Dropmark's servers
    public var directory: DKDirectory {
        return DKDirectory(collectionID: collectionID as NSNumber, stackID: parentID)
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
