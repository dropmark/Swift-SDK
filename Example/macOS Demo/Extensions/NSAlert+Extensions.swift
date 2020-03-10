//
//  NSAlert+Extensions.swift
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

import Cocoa
import DropmarkSDK

extension NSAlert {
    
    class func showOKAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        _ = alert.runModal() == .alertFirstButtonReturn
    }
    
    class func showOKAlert(error: Error) {
        
        if let serverError = error as? DKServerError {
            
            var message = "Server Error (\(serverError.statusCode))"
            
            if let serverErrorMessage = serverError.message {
                message += "\n"
                message += serverErrorMessage
            }
            
            showOKAlert(message: message)
            
        } else {
            
            let message = "Error\n\(error.localizedDescription)"
            showOKAlert(message: message)
            
        }
        
    }
    
}
