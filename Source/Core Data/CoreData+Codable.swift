//
//  CoreData+Codable.swift
//  Pods
//
//  Created by Alex Givens on 7/1/22.
//

import Foundation

public enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
