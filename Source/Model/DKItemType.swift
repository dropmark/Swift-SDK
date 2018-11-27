//
//  DKItemType.swift
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

/// High-level item representations handled by Dropmark. Item types are expressed as strings, and are thus comparable and printable. Item types, Universal Type Identifers, MIMEs, and file extensions are tightly integrated in the Dropmark SDK.
public enum DKItemType: String, CaseIterable {
    
    /// Represents a data file such as a JPEG, PNG, or HEIC image.
    case image
    
    /// Represents a data file such as a MPEG, MP4, or MOV video.
    case video
    
    /// Represents a data file such as a MP3, AAC, or WAV audio file.
    case audio
    
    /// Represents a string conforming to a URL scheme.
    case link
    
    /// Represents a string (potentially formatted with Markdown)
    case text
    
    /// Represents a hex color string.
    case color
    
    /// Special case item that behaves as a parent to other items.
    case stack
    
    /// An item not conforming to any of the other item types. Oftentimes this is a data file in a proprietary format, such as a Sketch or Photoshop file.
    case other
    
    /**
     
     Derive a Dropmark item type from a file's MIME type (such as "image/jpeg").
     
     - Parameters:
        - mimeType: The MIME type of the item's associated file
     
     - Returns: A Dropmark item type
     
     */
    
    public init?(mimeType: String) {
        
        guard let itemType = UTI(mimeType: mimeType)?.itemType else { return nil }
        self = itemType
        
    }
    
    /**
     
     Derive a Dropmark item type from a filename extension (like "jpg").
     
     - Parameters:
        - filenameExtension: The filename extension of the item's associated file
     
     - Returns: A Dropmark item type
     
     */
    
    public init?(filenameExtension: String) {
        
        guard let itemType = UTI(filenameExtension: filenameExtension)?.itemType else { return nil }
        self = itemType
        
    }
    
    /// String useful for displaying an item type on screen. Returns a capitalized version of the case value, except for `.other`, which returns "File"
    var displayTitle: String {
        
        switch self {
            
        case .other:
            return "File"
            
        default:
            return rawValue.capitalized
            
        }
        
    }
    
}
