//
//  ItemType.swift
//
//  Copyright © 2018 Oak, LLC (https://oak.is)
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

public enum ItemType : String {
    
    case image
    case video
    case audio
    case link
    case text
    case color
    case stack
    case other
    
    /**
     
     Derive a Dropmark Item Type from a file's MIME type (like "image/jpeg").
     
     - returns:
     A new item type
     
     - parameters:
     - mimeType: The MIME type of the item's associated file
     
     */
    
    public init?(fromMimeType mimeType: String?) {
        
        guard
            let mimeType = mimeType,
            let uti = UTI(mimeType: mimeType),
            let itemType = uti.itemType
            else { return nil }
        
        self = itemType
        
    }
    
    /**
     
     Derive a Dropmark Item Type from a filename extension (like "jpg").
     
     - returns:
     A new item type
     
     - parameters:
     - filenameExtension: The filename extension of the item's associated file
     
     */
    
    public init?(fromFilenameExtension filenameExtension: String?) {
        
        guard
            let filenameExtension = filenameExtension,
            let uti = UTI(filenameExtension: filenameExtension),
            let itemType = uti.itemType
            else { return nil }
        
        self = itemType
        
    }
    
    /**
     
     Capitalized title associated with the item type.
     
     */
    
    public var title: String {
        
        switch self {
            
        case .other:
            return "File"
            
        default:
            return rawValue.capitalized
            
        }
        
    }
    
}
