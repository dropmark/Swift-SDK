//
//  DKLocalStorage.swift
//  Pods
//
//  Created by Alex Givens on 8/2/22.
//

import Foundation

public class DKUserDefaults {

    enum LocalStorageError: Error {
        case unableToDecodeData
        case badDataType
    }

    public static var suiteName: String {
        set {
            _suiteName = newValue
        }
        get {
            assert(_suiteName != nil, "LocalStorage requires a suiteName be specifed to store and manage UserDefaults.")
            return _suiteName!
        }
    }

    private static var _suiteName: String?

    public static func saveObject(_ object: Any, forKey key: String) throws {
        let encodedData = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        UserDefaults(suiteName: suiteName)?.set(encodedData, forKey: key)
    }

    public static func loadObject<T>(forKey key: String) throws -> T {
        guard let decodedData = UserDefaults(suiteName: suiteName)?.data(forKey: key) else {
            throw LocalStorageError.unableToDecodeData
        }
        let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData)
        guard let castObject = object as? T else {
            throw LocalStorageError.badDataType
        }
        return castObject
    }

    public static func deleteObject(forKey key: String) {
        UserDefaults(suiteName: suiteName)?.removeObject(forKey: key)
    }

}

extension DKUserDefaults {
    
    struct Key {
        static let currentUserID = "com.dropmark.userdefaults.current_user_id"
    }
    
    public class var currentUserID: NSNumber? {
        get {
            if let existingAccountID: NSNumber = try? loadObject(forKey: Key.currentUserID) {
                return existingAccountID
            }
            return nil
        }
        set {
            if let newValue = newValue {
                do {
                    try saveObject(newValue, forKey: Key.currentUserID)
                } catch {
                    print("Unable to save the currentUserID to NSUserDefaults")
                }
            } else {
                deleteObject(forKey: Key.currentUserID)
            }
        }
    }
    
}
