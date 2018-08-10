//
//  DKThumbnails.swift
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

/// Represents the available thumbnails for a collection or item.
@objc(DKThumbnails)
public class DKThumbnails: NSObject, NSCoding {
    
    public var mini: URL?
    public var small: URL?
    public var cropped: URL?
    public var uncropped: URL?
    public var large: URL?
    public var croppedAnimated: URL?
    public var uncroppedAnimated: URL?
    
    // Init from network response
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any]
        else { return nil }
        
        if let urlString = representation["mini"] as? String  {
            mini = URL(string: urlString)
        }
        
        if let urlString = representation["small"] as? String  {
            small = URL(string: urlString)
        }
        
        if let urlString = representation["cropped"] as? String  {
            cropped = URL(string: urlString)
        }
        
        if let urlString = representation["uncropped"] as? String  {
            uncropped = URL(string: urlString)
        }
        
        if let urlString = representation["large"] as? String  {
            large = URL(string: urlString)
        }
        
        if let urlString = representation["cropped_animated"] as? String  {
            croppedAnimated = URL(string: urlString)
        }
        
        if let urlString = representation["uncropped_animated"] as? String  {
            uncroppedAnimated = URL(string: urlString)
        }
                
    }

    // MARK: NSCoding
    
    /**
     
     Returns an object initialized from data in a given unarchiver.
     
     - Parameters:
        - coder: An unarchiver object.
     
     - Returns: `self`, initialized using the data in `coder`.
     
     - Discussion: You typically return `self` from `init(coder:)`. If you have an advanced need that requires substituting a different object after decoding, you can do so in `awakeAfter(using:)`.
     
     */
    
    public required init(coder aDecoder: NSCoder) {
        
        mini = aDecoder.decodeObject(forKey: "mini") as? URL
        small = aDecoder.decodeObject(forKey: "small") as? URL
        cropped = aDecoder.decodeObject(forKey: "cropped") as? URL
        uncropped = aDecoder.decodeObject(forKey: "uncropped") as? URL
        large = aDecoder.decodeObject(forKey: "large") as? URL
        croppedAnimated = aDecoder.decodeObject(forKey: "cropped_animated") as? URL
        uncroppedAnimated = aDecoder.decodeObject(forKey: "uncropped_animated") as? URL
        
    }
    
    /**
     
     Encodes the receiver using a given archiver.
     
     - Parameters:
        - encoder: An archiver object.
     
     */
    
    public func encode(with aCoder: NSCoder) {

        aCoder.encode(mini, forKey: "mini")
        aCoder.encode(small, forKey: "small")
        aCoder.encode(cropped, forKey: "cropped")
        aCoder.encode(uncropped, forKey: "uncropped")
        aCoder.encode(large, forKey: "large")
        aCoder.encode(uncropped, forKey: "cropped_animated")
        aCoder.encode(large, forKey: "uncropped_animated")
        
    }
    
}
