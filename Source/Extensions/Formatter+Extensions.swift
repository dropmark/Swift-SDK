//
//  Formatter+Extensions.swift
//  Pods
//
//  Created by Alex Givens on 7/1/22.
//

import Foundation

public extension Formatter {
    
    static let dropmark: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
}
