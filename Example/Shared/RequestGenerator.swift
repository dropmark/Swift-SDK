//
//  RequestGenerator.swift
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

class RequestGenerator {
    
    static func authenticate(email: String, password: String) -> Promise<User> {
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        return request(Router.authenticate(parameters: parameters)).validate().responseObject()
    }
    
    static func listCollections() -> Promise<[DMCollection]> {
        return request(Router.listCollections(queryParameters: nil)).validate().responseList()
    }
    
    static func listItemsIn(collection: DMCollection) -> Promise<[Item]> {
        
        var queryParameters = Parameters()
        
        // Remove stack children from the listing
        queryParameters["parent_id"] = ""
        
        // Create request
        let itemsRequest = request(Router.listItemsInCollection(id: collection.id, queryParameters: queryParameters)).validate()
        
        return itemsRequest.responseList()
        
    }
    
    static func listItemsIn(collection: DMCollection, stack: Item) -> Promise<[Item]> {
        
        var queryParameters = Parameters()
        
        // Retrieve items within the parent stack
        queryParameters["parent_id"] = stack.id
        
        let itemsRequest = request(Router.listItemsInCollection(id: collection.id, queryParameters: queryParameters)).validate()
        
        return itemsRequest.responseList()
        
    }
    
}
