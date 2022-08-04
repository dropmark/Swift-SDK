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
    
    /// Assigns a string to the `kSecAttrService` value in the Keychain query. Used to identify what the Keychain entry is used for.
    @objc public static var service = "com.dropmark.app"
    
    /// Assigns a string to the `kSecAttrAccount` value in the Keychain query. Used primarily as a key to get the user data from Keychain.
    @objc public static var userKey = "com.dropmark.app"
    
    @objc public static var userAPIKey: String? {
        get {
            var query = keychainQuery()
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            query[kSecReturnAttributes as String] = true
            query[kSecReturnData as String] = true
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            printStatus(status)
            guard
                status == errSecSuccess,
                let existingItem = item as? [String : Any],
                let userAPIKeyData = existingItem[kSecValueData as String] as? Data,
                let userAPIKey = String(data: userAPIKeyData, encoding: .utf8)
            else {
                return nil
            }
            return userAPIKey
        }
        set {
            if let newValue = newValue {
                
                var query = keychainQuery()
                let stringData: Data? = newValue.data(using: .utf8, allowLossyConversion: false)
                query[kSecValueData as String] = stringData
                
                if // If an item already exists, update the record
                    SecItemCopyMatching(query as CFDictionary, nil) == noErr,
                    let data = stringData
                {
                    let status = SecItemUpdate(query as CFDictionary, NSDictionary(dictionary: [kSecValueData: data]))
                    printStatus(status)
                } else { // Otherwise add a new record
                    let status = SecItemAdd(query as CFDictionary, nil)
                    printStatus(status)
                }
                
            } else {
                let query = keychainQuery()
                let status = SecItemDelete(query as CFDictionary)
                printStatus(status)
            }
        }
    }
    
    // MARK: Utility
    
    @objc public static func setUserAPIKeyWith(userID: NSNumber, userToken: String) throws {
        let plainString = "\(userID):\(userToken)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        guard let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else {
            throw DKError.unableToSerializeItem
        }
        self.userAPIKey = base64String
    }
    
    private static func keychainQuery() -> [String: Any] {
        var query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: userKey,
        ] as [String: Any]
        if let accessGroup = self.accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        return query
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
