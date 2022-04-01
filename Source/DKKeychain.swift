//
//  DKKeychain.swift
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

/// Provides encryption, decryption, and removal of an authenticated user object in the device keychain.
@objc public class DKKeychain: NSObject {
    
    /// Assigns a string to the `kSecAttrAccessGroup` value in the Keychain query. Recommended if you need to share user credentials between multiple app targets.
    @objc public static var accessGroup: String?
    
    /// Assigns a string to the `kSecAttrService` value in the Keychain query. Used to identify which app or service this keychain record is used for.
    @objc public static var service = "com.dropmark.app"
    
    /// Assigns a string to the `kSecAttrAccount` value in the Keychain query. Used to identify the account for this keychain record. Typically this is the user's email address.
    @objc public static var userKey = "com.dropmark.user"
    
    /// A common set of query parameters used to set, retrieve, and delete
    @objc public static var baseQuery: [String: Any] {
        var query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: userKey
        ] as [String: Any]
        if let accessGroup = self.accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        return query
    }
    
    /// The user is stored in the device keychain. Use this variable to securely retrieve the representation of the credentialed user. Note: If the user obect does not contain a `token`, the user will not be stored.
    @objc public static var user: DKUser? {
        
        get {
            var query = baseQuery
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            query[kSecReturnAttributes as String] = true
            query[kSecReturnData as String] = true
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            printStatus(status)
            guard
                status == errSecSuccess,
                let existingItem = item as? [String : Any],
                let userData = existingItem[kSecValueData as String] as? Data,
                let user = try? NSKeyedUnarchiver.unarchivedObject(ofClass: DKUser.self, from: userData)
            else {
                return nil
            }
            return user
        }
        
        set {
            if let newValue = newValue {
                guard newValue.token != nil else {
                    print("Attempting to store a user object without a token! Only the user object returned by the `/auth` API endpoint can operate as a user credential.")
                    return
                }
                
                guard
                    let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: true) as CFData
                else {
                    print("An error occurred archiving the DKUser data.")
                    return
                }
                var attributes = baseQuery
                attributes[kSecValueData as String] = data
                let status = SecItemAdd(attributes as CFDictionary, nil)
                printStatus(status)
            } else {
                let status = SecItemDelete(baseQuery as CFDictionary)
                printStatus(status)
            }
        }
        
    }
    
    private static func printStatus(_ status: OSStatus) {
        if #available(iOS 11.3, tvOS 11.3, *) {
            let statusMessage = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error"
            print("DKKeychain: \(statusMessage)")
        } else {
            print("DKKeychain OSStatus: \(status)")
        }
    }
    
}

