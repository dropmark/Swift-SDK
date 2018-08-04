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
import Alamofire
import PromiseKit
import DropmarkSDK

class LoginViewController: NSViewController {
    
    let showNavigatorSegueIdentifier = "ShowNavigatorController"

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
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if let existingUser = DKKeychain.user {
            showOKAlertWith(text: "Already logged in as \(existingUser.name!)!")
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func didPressLoginButton(_ sender: Any) {
        
        let email = emailTextField.stringValue
        let password = passwordTextField.stringValue
        
        isLoading = true
        
        firstly {
            RequestGenerator.authenticate(email: email, password: password)
        }.done {
            
            DKKeychain.user = $0 // Securely store the user for future app sessions
            DKRouter.user = $0 // Authenticate requests for the current app session
            
            let identifer = NSStoryboardSegue.Identifier.init(self.showNavigatorSegueIdentifier)
            self.performSegue(withIdentifier: identifer, sender: nil)
            
//            self.showOKAlertWith(text: "Successfully logged in as \($0.name!)!")
            
//            self.passwordTextField.stringValue = ""
//            self.emailTextField.stringValue = ""
            
        }.ensure {
            self.isLoading = false
        }.catch { error in
            self.showOKAlertWith(text: error.localizedDescription)
        }
        
    }
    
    @discardableResult
    func showOKAlertWith(text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
}

