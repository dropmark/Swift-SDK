//
//  UTIKit+Extensions.swift
//
//  Copyright © 2020 Oak, LLC (https://oak.is)
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
#if os(iOS) || os(tvOS)
import MobileCoreServices
#endif

public extension UTI {
    
    /// Derive a Dropmark item type from a Universal Type Identifier.
    
    var itemType: DKItemType? {
        
        switch self {
            
        case UTI(kUTTypeText as String):
            return .text
            
        case UTI(kUTTypeURL as String):
            if self == UTI(kUTTypeFileURL as String) { // If the URL is a file URL
                return .other
            } else { // Else if the URL is a domain location
                return .link
            }
            
        case UTI(kUTTypeImage as String):
            return .image
            
        case UTI(kUTTypeMovie as String):
            return .video
            
        case UTI(kUTTypeAudio as String):
            return .audio
            
        case UTI(kUTTypeData as String):
            return .other
            
        default:
            return nil
            
        }
        
    }
    
}
