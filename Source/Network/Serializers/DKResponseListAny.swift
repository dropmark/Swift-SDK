//
//  DKResponseListAny.swift
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

/// Similar to `DKResponseListSerializable`, the `DKResponseListAny` is a serializer that generates an array of objects of any type. This extension is useful when handling results from Dropmark's `/activity` endpoint, which returns a variety of object types.
public struct DKResponseListAny {
    
    /**
     
     Serializes a list of new objects (of DKCollection, DKItem, DKReaction, DKComment, or DKInvite types) from the provided network response and key-value representation. The representation is validated for the required list.
     
     - Parameters:
        - response: A network response assocated with serialization
        - representation: A key-value object representing a list of objects.
     
     */
    
    public static func list(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Any] {
        
        var list: [Any] = []
        
        guard let listRepresentation = representation as? [[String: AnyObject]] else { return list }
            
        for objectRepresentation in listRepresentation {
            
            if let item = DKItem(response: response, representation: objectRepresentation) {
                
                list.append(item)
                
            } else if let collection = DKCollection(response: response, representation: objectRepresentation) {
                
                list.append(collection)
                
            }  else if let comment = DKComment(response: response, representation: objectRepresentation) {
                
                list.append(comment)
                
            } else if let reaction = DKReaction(response: response, representation: objectRepresentation) {
                
                list.append(reaction)
                
            } else if let invite = DKInvite(response: response, representation: objectRepresentation) {
                
                list.append(invite)
                
            }
            
        }
        
        return list
        
    }
    
}

public extension DataRequest {
    
    @discardableResult
    public func responseListAny(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[Any]>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<[Any]> { request, response, data, error in
            
            if let error = error {
                if let serverError = DKServerError(response: response, data: data) {
                    return .failure(serverError)
                } else {
                    return .failure(error)
                }
            }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(DKError.unableToSerializeJSON)
            }
            
            guard let response = response else {
                return .failure(DKError.unableToSerializeItem)
            }
            
            return .success(DKResponseListAny.list(from: response, withRepresentation: jsonObject))
            
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
        
    }
    
}
