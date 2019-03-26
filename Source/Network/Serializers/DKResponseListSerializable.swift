//
//  DKResponseListSerializable.swift
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

/// When applied to classes in Dropmark's model, a class conforming to `DKResponseListSerializable` can be serialized from JSON into an array of objects.
public protocol DKResponseListSerializable {
    
    /**
     
     Serializes a list of new objects (of a specified type) from the provided network response and key-value representation. The representation is validated for the required list.
     
     - Parameters:
        - response: A network response assocated with serialization
        - representation: A key-value object representing a list of objects.
     
     */
    
    static func list(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self]
    
}

public extension DKResponseListSerializable where Self: DKResponseObjectSerializable {
    
    static func list(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self] {
        
        var list: [Self] = []
        
        if let representation = representation as? [[String: Any]] {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation) {
                    list.append(item)
                }
            }
        }
        
        return list
        
    }
    
}

public extension DataRequest {
    
    @discardableResult
    func responseList<T: DKResponseListSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            
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
            
            return .success(T.list(from: response, withRepresentation: jsonObject))
            
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
        
    }
    
}
