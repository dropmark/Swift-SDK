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
@objc public class DKKeychainOld: NSObject {
    
    /// Assigns a string to the `kSecAttrAccessGroup` value in the Keychain query. Recommended if you need to share user credentials between multiple app targets.
    @objc public static var accessGroup: String?
    
    /// Assigns a string to the `kSecAttrService` value in the Keychain query. Used to identify what the Keychain entry is used for.
    @objc public static var service = "com.dropmark.key"
    
    /// Assigns a string to the `kSecAttrAccount` value in the Keychain query. Used primarily as a key to get the user data from Keychain.
    @objc public static var userKey = "com.dropmark.key"
    
    /// The user is stored in the device keychain. Use this variable to securely retrieve the representation of the credentialed user. Note: If the user obect does not contain a `token`, the user will not be stored.
//    @objc public static var user: DKUser? {
//
//        get {
//            var query = baseQuery
//            query[kSecMatchLimit as String] = kSecMatchLimitOne
//            query[kSecReturnAttributes as String] = true
//            query[kSecReturnData as String] = true
//            var item: CFTypeRef?
//            let status = SecItemCopyMatching(query as CFDictionary, &item)
//            printStatus(status)
//            guard
//                status == errSecSuccess,
//                let existingItem = item as? [String : Any],
//                let userData = existingItem[kSecValueData as String] as? Data,
//                let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? DKUser
//            else {
//                return nil
//            }
//            return user
//        }
//
//        set {
//            if let newValue = newValue {
//                guard newValue.token != nil else {
//                    print("Attempting to store a user object without a token! Only the user object returned by the `/auth` API endpoint can operate as a user credential.")
//                    return
//                }
//                let data = NSKeyedArchiver.archivedData(withRootObject: newValue) as CFData
//                var attributes = baseQuery
//                attributes[kSecValueData as String] = data
//                let status = SecItemAdd(attributes as CFDictionary, nil)
//                printStatus(status)
//            } else {
//                let status = SecItemDelete(baseQuery as CFDictionary)
//                printStatus(status)
//            }
//        }
//
//    }
    
    @objc public static func setUserAPIKeyWith(userID: NSNumber, userToken: String) throws {
        let plainString = "\(userID):\(userToken)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        guard let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else {
            throw DKError.unableToSerializeItem
        }
        self.userAPIKey = base64String
    }
    
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
                query[kSecValueData as String] = data
                let status = SecItemAdd(query as CFDictionary, nil)
                printStatus(status)
            } else {
                let query = keychainQuery()
                let status = SecItemDelete(query as CFDictionary)
                printStatus(status)
            }
        }
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
    
    @objc public static var userDictionary: NSDictionary? {
        
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
            let data = existingItem[kSecValueData as String] as? Data,
            let dictionary = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: data)
        else {
            return nil
        }
        return dictionary
        
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

@objc public class DKKeychain: NSObject {
    
    /// Assigns a string to the `kSecAttrAccessGroup` value in the Keychain query. Recommended if you need to share user credentials between multiple app targets.
    @objc public static var accessGroup: String?
    
    /// Assigns a string to the `kSecAttrService` value in the Keychain query. Used to identify what the Keychain entry is used for.
    @objc public static var service = "com.dropmark.key"
    
    /// Assigns a string to the `kSecAttrAccount` value in the Keychain query. Used primarily as a key to get the user data from Keychain.
    @objc public static var userKey = "com.dropmark.key"
    
    public static var loggingEnabled = false
    
    
//    open subscript(key: String) -> String? {
//        get {
//            return load(withKey: key)
//        } set {
//            DispatchQueue.global().sync(flags: .barrier) {
//                self.save(newValue, forKey: key)
//            }
//        }
//    }
    
    private static func save(_ string: String?, forKey key: String) {
        let query = keychainQuery()
        let objectData: Data? = string?.data(using: .utf8, allowLossyConversion: false)

        if SecItemCopyMatching(query, nil) == noErr {
            if let dictData = objectData {
                let status = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
                logPrint("Update status: ", status)
            } else {
                let status = SecItemDelete(query)
                logPrint("Delete status: ", status)
            }
        } else {
            if let dictData = objectData {
                query.setValue(dictData, forKey: kSecValueData as String)
                let status = SecItemAdd(query, nil)
                logPrint("Update status: ", status)
            }
        }
    }
    
    private static func load(withKey key: String) -> String? {
        let query = keychainQuery()
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        
        guard
            let resultsDict = result as? NSDictionary,
            let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data,
            status == noErr
            else {
                logPrint("Load status: ", status)
                return nil
        }
        return String(data: resultsData, encoding: .utf8)
    }
    
    private static func keychainQuery() -> NSMutableDictionary {
        let result = NSMutableDictionary()
        result.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        result.setValue(service, forKey: kSecAttrService as String)
        result.setValue(userKey, forKey: kSecAttrAccount as String)
        result.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        if let accessGroup = self.accessGroup {
            result[kSecAttrAccessGroup as String] = accessGroup
        }
        return result
    }
    
    private static func logPrint(_ items: Any...) {
        if loggingEnabled {
            print(items)
        }
    }
}
