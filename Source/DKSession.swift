//
//  DKSession.swift
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

/// Memory-based storage for credentials within the current app session. Must be reconfigured every time the app leaves memory.
public struct DKSession {
    
    /// The user used to authenticate all network requests during lifetime of the app session.
    public static var user: DKUser?
    
    /// The token used to authenticate all network requests on behalf of a user. You can retrieve a token from the token variable of a DKUser returned by the `/auth` API endpoint.
    public static var userToken: String?
    
    /// The token used to authenticate all requests with the Dropmark API. Set this token as soon as the app starts to ensure generated requests are properly authenticated. The variable can be set manually, or optionally set by a `keys.plist` file belonging to the target.
    public static var apiToken: String? {
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
    
    /// Convenience function to store the user and user's token
    public static func store(user: DKUser, userToken: String) {
        DKSession.user = user
        DKSession.userToken = userToken
    }
    
    /// Convenience function to clear all variables in the session
    public static func clear() {
        DKSession.user = nil
        DKSession.userToken = nil
    }
    
}
