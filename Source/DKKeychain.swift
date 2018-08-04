//
//  DKKeychain.swift
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
import KeychainSwift

public struct DKKeychain {
    
    private static let userKey = "com.dropmark.user"
    
    public static var user: DKUser? {
        
        get {
            if
                let userData = KeychainSwift().getData(userKey),
                let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? DKUser
            {
                return user
            }
            return nil
        }
        
        set {
            if let newValue = newValue {
                let userData = NSKeyedArchiver.archivedData(withRootObject: newValue)
                KeychainSwift().set(userData, forKey: userKey, withAccess: .accessibleAlways)
            } else {
                KeychainSwift().delete(userKey)
            }
        }
        
    }
    
}
