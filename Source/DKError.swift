//
//  DKError.swift
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

/// Errors associated with points of failure in the SDK
public enum DKError: Error {
    
    /// The pagination object reached the end of the object list
    case paginationDidReachEnd
    
    /// The pagination object is currently in the process of getting a new page of objects
    case paginationIsFetchingPage
    
    /// The incoming JSON is in an unexpected format
    case unableToSerializeJSON
    
    /// An error occurred while trying to create an object from the network response
    case unableToSerializeItem
    
    /// An API `token` is missing from the `DKRouter.user` property
    case missingAPIToken
    
    /// A user object is needed but not present
    case missingUser
    
    /// A user token is needed but not present
    case missingUserToken
    
    /// Request was deallocated from memory before a response could be returned
    case requestIsNil
    
    /// Request found itself deallocated
    case deallocated
    
    /// User explicitly cancelled the operation
    case userCancelled
    
}
