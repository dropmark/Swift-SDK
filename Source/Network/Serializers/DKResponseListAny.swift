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
    
    enum ObjectType: String {
        case collection
        case item
        case reaction
        case comment
        case invite
    }
    
    public static func list(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Any] {
        
        var list: [Any] = []
        
        guard let listRepresentation = representation as? [[String: AnyObject]] else { return list }
            
        for objectRepresentation in listRepresentation {
            
            guard
                let objectTypeRawValue = objectRepresentation["type"] as? String,
                let objectType = ObjectType(rawValue: objectTypeRawValue)
            else { continue }
            
            switch objectType {
                
            case .collection:
                if let collection = DKCollection(response: response, representation: objectRepresentation) {
                    list.append(collection)
                }
                
            case .item:
                if let item = DKItem(response: response, representation: objectRepresentation) {
                    list.append(item)
                }
                
            case .reaction:
                if let reaction = DKReaction(response: response, representation: objectRepresentation) {
                    list.append(reaction)
                }
                
            case .comment:
                if let comment = DKComment(response: response, representation: objectRepresentation) {
                    list.append(comment)
                }
                
            case .invite:
                if let invite = DKInvite(response: response, representation: objectRepresentation) {
                    list.append(invite)
                }
                
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
                return .failure(DKSerializationError.invalidJSON)
            }
            
            guard let response = response else {
                return .failure(DKSerializationError.unableToFormObject)
            }
            
            return .success(DKResponseListAny.list(from: response, withRepresentation: jsonObject))
            
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
        
    }
    
}
