//
//  DKThumbnails.swift
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

/// Represents the available thumbnails for a collection or item.
public struct DMThumbnails: Codable {
    
    /// URL for a mini thumbnail image, preserving the content's aspect ratio
    public var mini: URL?
    
    /// URL for a small thumbnail image, preserving the content's aspect ratio
    public var small: URL?
    
    /// URL for a cropped thumbnail image, using a square aspect ratio
    public var cropped: URL?
    
    /// URL for an uncropped thumbnail image, preserving the content's aspect ratio
    public var uncropped: URL?
    
    /// URL for a large thumbnail image, preserving the content's aspect ratio
    public var large: URL?
    
    /// For GIF animations, a URL for a cropped thumbnail animation using a square aspect ratio.
    public var croppedAnimated: URL?
    
    /// For GIF animations, a URL for an uncropped thumbnail animation preserving the content's aspect ratio
    public var uncroppedAnimated: URL?
    
    public enum CodingKeys: String, CodingKey {
        case mini
        case small
        case cropped
        case uncropped
        case large
        case croppedAnimated = "cropped_animated"
        case uncroppedAnimated = "uncropped_animated"
    }
    
}
