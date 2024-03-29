//
//  DKSession.swift
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

/// Memory-based storage for credentials within the current app session. Must be reconfigured every time the app leaves memory.
@objc public class DKSession: NSObject {
    
    /// The user object used to authenticate all network requests during lifetime of the app session. This object must contain a `token` to authenticate the network requests. A user with the `token` variable is only returned by the `/auth` API endpoint.
    @objc public static var user: DKUser?
    
    /// The token used to authenticate all requests with the Dropmark API. Set this token as soon as the app starts to ensure generated requests are properly authenticated. The variable can be set manually on app launch, or optionally set by a `keys.plist` file belonging to the target.
    @objc public static var apiToken: String? {
        get {
            if let manualToken = _apiToken {
                return manualToken
            } else if let bundleToken = Bundle.keyForID("DropmarkAPIToken") {
                return bundleToken
            }
            print("Dropmark API Token was not found.")
            return nil
        }
        set {
            _apiToken = newValue
        }
    }
    
    private static var _apiToken: String?
    
}
