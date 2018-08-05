//
//  Error.swift
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

extension Error {
    public var code: Int { return (self as NSError).code }
    public var domain: String { return (self as NSError).domain }
}

public enum DKPaginationError: Error {
    case didReachEnd
    case isFetchingPage
}

public enum DKSerializationError: Error {
    case invalidJSON
    case unableToFormObject
}

public enum DKRouterError: Error {
    case missingUser
    case missingUserToken
}

public struct DKServerError: Error {
    
    public init?(response: HTTPURLResponse?, data: Data?) {
        
        guard let statusCode = response?.statusCode else {
            return nil
        }
        
        self.statusCode = statusCode
        
        if
            let data = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers),
            let jsonDict = jsonObject as? [String:AnyObject],
            let message = jsonDict["message"] as? String
        {
            self.message = message
        }
        
    }
    
    public var statusCode: Int
    public var message: String?
    
}