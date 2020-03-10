//
//  PromiseGenerator.swift
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
import PromiseKit
import DropmarkSDK

/// Create network requests and assign them to promises. When the promise is executed, response data is serialized into JSON, then into the appropriate type. Customize this generator for your app to for legible promise chains.
struct PromiseGenerator {
    
    /**
     
     Authenticate a user's credentials to recieve a user object and associated token.
 
     - Parameters:
        - email: The email associated with the user's account
        - password: The password associated with the user's account
     
     - Returns: A promise resulting in a tuple if successful. The tuple will contain the Dropmark user object and user token.
     
     */
    
    static func authenticate(email: String, password: String) -> CancellablePromise<DKUser> {
        
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        return request(DKRouter.authenticate(parameters: parameters)).validate().promiseObject()
        
    }
    
    /**
     
     Get a list of collections associated with the current user.
     
     - Parameters:
        - page: Dropmark's API paginates list responses. Specify the page, along with page size in `DKRouter`, to specify what content to retreive in the list.
     
     - Returns: A promise resulting in a list of Dropmark collections if successful.
     
     - Note: Lists may be filtered according to various query parameters specified by the Dropmark API. Check out the API documentation for a full list of available query paramters.
     
     */
    
    static func listCollections(page: Int) -> CancellablePromise<[DKCollection]> {
        
        let parameters: Parameters = [
            "page": page
        ]
        
        let collectionsRequest = request(DKRouter.listCollections(queryParameters: parameters)).validate()
        
        return collectionsRequest.promiseList()
        
    }
    
    /**
     
     Get a list of items contained within a specified collection, and optionally a specified stack.
     
     - Parameters:
        - collection: The parent collection of the desired items.
        - stack: The parent stack of the desired items.
        - page: Dropmark's API paginates list responses. Specify the page, along with page size in `DKRouter`, to specify what content to retreive in the list.
     
     - Returns: A promise resulting in a list of Dropmark items if successful.
     
     - Note: Lists may be filtered according to various query parameters specified by the Dropmark API. Check out the API documentation for a full list of available query paramters.
     
     */
    
    static func listItems(collection: DKCollection, stack: DKItem?, page: Int) -> CancellablePromise<[DKItem]> {
        
        var parameters: Parameters = [
            "page": page
        ]
        
        if let stack = stack {
            parameters["parent_id"] = stack.id
        } else {
            parameters["parent_id"] = ""
        }
        
        let itemsRequest = request(DKRouter.listItemsInCollection(id: collection.id, queryParameters: parameters)).validate()
        
        return itemsRequest.promiseList()
        
    }
    
}
