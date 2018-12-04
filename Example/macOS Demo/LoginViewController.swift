//
//  LoginViewController.swift
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

import Cocoa
import PromiseKit
import DropmarkSDK

class LoginViewController: NSViewController {
    
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var isLoading: Bool = false {
        didSet {
            emailTextField.isEnabled = !isLoading
            passwordTextField.isEnabled = !isLoading
            loginButton.isHidden = isLoading
            if isLoading {
                progressIndicator.startAnimation(nil)
            } else {
                progressIndicator.stopAnimation(nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.nextKeyView = passwordTextField
        
        // If a user and token already exist in our keychain, skip login
        if
            let user = DKKeychain.user,
            let userToken = DKKeychain.userToken
        {
            
            // Authenticate requests for the current app session
            DKSession.store(user: user, userToken: userToken)
            
            // Add a slight delay due to rendering issue with view layers
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.showMainViewController, sender: nil)
            }
            
        }
        
    }

    @IBAction func didPressLoginButton(_ sender: Any) {
        
        let email = emailTextField.stringValue
        let password = passwordTextField.stringValue
        
        guard email.count > 0, password.count > 0 else {
            let message = "Missing Field\nPlease enter an email and password for your Dropmark account."
            NSAlert.showOKAlert(message: message)
            return
        }
        
        isLoading = true
        
        firstly {
            
            PromiseGenerator.authenticate(email: email, password: password)
        
        }.done {
            
            DKKeychain.store(user: $0, userToken: $1) // Securely store the user and token for future app sessions
            DKSession.store(user: $0, userToken: $1) // Retain the user and token for the current app session
            
            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.showMainViewController, sender: nil)
            
            self.passwordTextField.stringValue = ""
            self.emailTextField.stringValue = ""
            
        }.ensure {
            
            self.isLoading = false
            
        }.catch { error in
            
            NSAlert.showOKAlert(error: error)
                
        }
        
    }
    
}

