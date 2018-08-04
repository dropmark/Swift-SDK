//
//  DataRequest+PromiseKit.swift
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

public extension DataRequest {
    
    /// Generate a promise without any return objects
    public func responseGeneric() -> Promise<Void> {
        return Promise<Void> { seal in
            self.response { response in
                if let error = response.error {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            }
        }
    }
    
    public func responseObject<T: DKResponseObjectSerializable>() -> Promise<T> {
        return Promise<T> { seal in
            self.responseObject { (response: DataResponse<T>) in
                seal.resolve(response.result.error, response.result.value)
            }
        }
    }
    
    public func responseList<T: DKResponseListSerializable>() -> Promise<[T]> {
        return Promise<[T]> { seal in
            self.responseList { (response: DataResponse<[T]>) in
                seal.resolve(response.result.error, response.result.value)
            }
        }
    }
    
    public func responseListAny() -> Promise<[Any]> {
        return Promise<[Any]> { seal in
            self.responseListAny { (response: DataResponse<[Any]>) in
                seal.resolve(response.result.error, response.result.value)
            }
        }
    }
    
}
