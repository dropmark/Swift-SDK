//
//  UIAlertController+Extensions.swift
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

import UIKit
import DropmarkSDK

extension UIAlertController {
    
    convenience init(title: String?, message: String?) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "OK", style: .default))
    }
    
    convenience init(error: Error) {
        
        print(error)
        print(error.localizedDescription)
        
        if let serverError = error as? DKServerError {
            
            let title = "Server Error (\(serverError.statusCode))"
            let message = serverError.message
            self.init(title: title, message: message)
            
        } else {
            
            self.init(title: "Error", message: error.localizedDescription)
            
        }
        
    }
    
}
