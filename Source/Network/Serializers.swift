//
//  Serializers.swift
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

public extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

// MARK: Single objects

public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: Any)
}

public extension DataRequest {
    
    @discardableResult
    public func responseObject<T: ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else {
                
                if error!.code == -999 {
                    return .failure(NetworkError.userCancelled)
                }
                
                let statusCode = response?.statusCode ?? 0
                
                if statusCode == 0 {
                    return .failure(NetworkError.offline)
                }
                
                var message = ""
                if let data = data {
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                        if let serverErrorMessage = jsonDict["message"] as? String {
                            message = serverErrorMessage
                        }
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                    }
                }
                
                return .failure(NetworkError.network(statusCode: statusCode, message: message, error: error!))
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(NetworkError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
                return .failure(NetworkError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
            }
            
            return .success(responseObject)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

// MARK: List of objects of Type

public protocol ResponseListSerializable {
    static func list(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self]
}

public extension ResponseListSerializable where Self: ResponseObjectSerializable {
    public static func list(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self] {
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
    public func responseList<T: ResponseListSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            guard error == nil else {
                
                if error!.code == -999 {
                    return .failure(NetworkError.userCancelled)
                }
                
                let statusCode = response?.statusCode ?? 0
                
                if statusCode == 0 {
                    return .failure(NetworkError.offline)
                }
                
                var message = ""
                if let data = data {
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                        if let serverErrorMessage = jsonDict["message"] as? String {
                            message = serverErrorMessage
                        }
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                    }
                }
                
                return .failure(NetworkError.network(statusCode: statusCode, message: message, error: error!))
            }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(NetworkError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response else {
                let reason = "Response collection could not be serialized due to nil response."
                return .failure(NetworkError.objectSerialization(reason: reason))
            }
            
            return .success(T.list(from: response, withRepresentation: jsonObject))
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

// MARK: List of objects of any Type


public extension DataRequest {
    
    @discardableResult
    public func responseResults(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[Any]>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<[Any]> { request, response, data, error in
            guard error == nil else {
                
                if error!.code == -999 {
                    return .failure(NetworkError.userCancelled)
                }
                
                let statusCode = response?.statusCode ?? 0
                
                if statusCode == 0 {
                    return .failure(NetworkError.offline)
                }
                
                var message = ""
                if let data = data {
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                        if let serverErrorMessage = jsonDict["message"] as? String {
                            message = serverErrorMessage
                        }
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                    }
                }
                
                return .failure(NetworkError.network(statusCode: statusCode, message: message, error: error!))
            }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(NetworkError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response else {
                let reason = "Response collection could not be serialized due to nil response."
                return .failure(NetworkError.objectSerialization(reason: reason))
            }
            
            var list = [Any]()
            
            if let listRepresentation = jsonObject as? [[String: AnyObject]] {
                for objectRepresentation in listRepresentation {
                    
                    if let type = objectRepresentation["type"] as? String {
                        
                        switch type {
                            
                        case "collection":
                            if let collection = DMCollection(response: response, representation: objectRepresentation) {
                                list.append(collection)
                            }
                            
                        case "reaction":
                            if let reaction = Reaction(response: response, representation: objectRepresentation) {
                                list.append(reaction)
                            }
                            
                        case "comment":
                            if let comment = DMComment(response: response, representation: objectRepresentation) {
                                list.append(comment)
                            }
                            
                        case "invite":
                            if let invite = Invite(response: response, representation: objectRepresentation) {
                                list.append(invite)
                            }
                            
                        default:
                            if let item = Item(response: response, representation: objectRepresentation) {
                                list.append(item)
                            }
                            
                        }
                    }
                }
            }
            
            return .success(list)
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
