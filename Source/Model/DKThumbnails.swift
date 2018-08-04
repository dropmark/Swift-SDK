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

/**

 Represents the available thumbnails for a collection or item.
 
*/

@objc(DKThumbnails)
public class DKThumbnails: NSObject, NSCoding {
    
    public var mini: String?
    public var small: String?
    public var cropped: String?
    public var uncropped: String?
    public var large: String?
    public var croppedAnimated: String?
    public var uncroppedAnimated: String?
    
    // Init from Alamofire
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard
            let representation = representation as? [String: Any]
        else { return nil }
        
        mini = representation["mini"] as? String
        small = representation["small"] as? String
        cropped = representation["cropped"] as? String
        uncropped = representation["uncropped"] as? String
        large = representation["large"] as? String
        croppedAnimated = representation["cropped_animated"] as? String
        uncroppedAnimated = representation["uncropped_animated"] as? String
        
    }

    // Init from NSUserDefaults
    public required init(coder aDecoder: NSCoder) {
        
        mini = aDecoder.decodeObject(forKey: "mini") as? String
        small = aDecoder.decodeObject(forKey: "small") as? String
        cropped = aDecoder.decodeObject(forKey: "cropped") as? String
        uncropped = aDecoder.decodeObject(forKey: "uncropped") as? String
        large = aDecoder.decodeObject(forKey: "large") as? String
        croppedAnimated = aDecoder.decodeObject(forKey: "cropped_animated") as? String
        uncroppedAnimated = aDecoder.decodeObject(forKey: "uncropped_animated") as? String
        
    }
    
    // Save to NSUserDefaults
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
