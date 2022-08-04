//
//  DKAccount.swift
//
//  Copyright © 2022 Oak, LLC (https://oak.is)
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

/// Use this protocol for interchangeable usage of DKUsers and DKTeams
public protocol DKAccount {
    
    var id: NSNumber { get set }
    var name: String { get set }
    var email: String? { get set }
    var username: String? { get set }
    var customDomain: String? { get set }
    var avatar: URL? { get set }
    var plan: DKPlan { get set }
    var planIsActive: Bool? { get set }
    var storageQuota: NSNumber { get set }
    var storageUsed: NSNumber { get set }
    var billingEmail: String?  { get set }
    
}

public extension DKAccount {
    
    var displayName: String {
        if
            let currentUserID = DKUserDefaults.currentUserID,
            currentUserID == self.id
        {
            return "Personal"
        }
        return name
    }
    
    var storageProgress: Progress {
        
        let progress = Progress(totalUnitCount: storageQuota.int64Value)
        progress.completedUnitCount = storageUsed.int64Value
        
        let used = ByteCountFormatter.string(fromByteCount: storageUsed.int64Value, countStyle: .memory)
        let quota = ByteCountFormatter.string(fromByteCount: storageQuota.int64Value, countStyle: .memory)
        let percent = storageUsed.floatValue/storageQuota.floatValue * 100
        // Trims the percent to two decimal places
        let percentTrimmed = round(100.0 * percent) / 100.0
        
        progress.localizedDescription = "\(used) of \(quota) (\(percentTrimmed)%)"
        
        return progress
        
    }
    
}
