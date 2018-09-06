//
//  Dictionary+Parameters.swift
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
import Alamofire

extension Dictionary {
    
    static func listParams() -> Parameters {
        var dictionary = Parameters()
        dictionary.addListParams()
        return dictionary
    }
    
    static func collectionParams() -> Parameters {
        var dictionary = Parameters()
        dictionary.addCollectionParams()
        return dictionary
    }
    
    static func itemParams() -> Parameters {
        var dictionary = Parameters()
        dictionary.addItemParams()
        return dictionary
    }
    
    static func userParams() -> Parameters {
        var dictionary = Parameters()
        dictionary.addUserParams()
        return dictionary
    }
    
    mutating func addListParams() {
        self.add(key: "per_page", value: DKRouter.pageSize)
    }
    
    mutating func addCollectionParams() {
        self.add(key: "include", value: ["users", "items"])
        self.add(key: "items_per_page", value: 4)
        self.add(key: "items_not_type", value: "stack")
    }
    
    mutating func addItemParams() {
        self.add(key: "include", value: ["items"])
        self.add(key: "items_per_page", value: 4)
    }
    
    mutating func addUserParams() {
        self.add(key: "include", value: ["teams"])
    }
    
    mutating func add(key: String, value: Any) {
        if
            let uKey = key as? Key,
            let uValue = value as? Value,
            self[uKey] == nil
        {
            self[uKey] = uValue
        }
    }
    
}
