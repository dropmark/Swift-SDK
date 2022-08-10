//
//  LoginViewController.swift
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
import PromiseKit
import DropmarkSDK

class LoginViewController: UIViewController {
    
    enum LoginError: Error {
        case noCredentialsFound
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool = false {
        didSet {
            emailTextField.isEnabled = !isLoading
            passwordTextField.isEnabled = !isLoading
            loginButton.isHidden = isLoading
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoading = true
        
        authenticateExistingCredentials().done { [weak self] user in
            
            DKUserDefaults.currentUserID = user.id

            let collectionListViewController = UIStoryboard.collectionListViewController
            self?.navigationController?.pushViewController(collectionListViewController, animated: false)
            
        }.ensure { [weak self] in
            
            self?.isLoading = false
            
        }.catch { error in
            
            if
                let serverError = error as? DKServerError,
                (400..<500).contains(serverError.statusCode)
            {
                let title = "Credentials invalid"
                let message = "Please re-enter your email and password for your Dropmark account."
                let alert = UIAlertController(title: title, message: message)
                self.present(alert, animated: true)
            }
            
        }
        
    }
    
    // Check for an existing API Key in the Keychain, then refresh the user object to test the key
    func authenticateExistingCredentials() -> Promise<DKUser> {
        guard
            let apiKey = DKKeychain.userAPIKey,
            apiKey.isEmpty == false
        else { return Promise(error: LoginError.noCredentialsFound) }
        return DKPromise.getUser().asPromise()
    }
    
    @IBAction func didPressLoginButton(_ sender: Any) {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else {
            let title = "Missing field"
            let message = "Please enter an email and password for your Dropmark account."
            let alert = UIAlertController(title: title, message: message)
            self.present(alert, animated: true)
            return
        }
        
        isLoading = true
                
        firstly {
            
            DKPromise.authenticate(parameters: ["email": email, "password": password])
            
        }.compactMap { (user: DKUser, token: String) in
            try DKKeychain.setUserAPIKeyWith(userID: user.id, userToken: token)
            return user
        }.done { (user: DKUser) in
            
            DKUserDefaults.currentUserID = user.id
            
            if let userID = DKUserDefaults.currentUserID {
                print("Got user id: \(userID)")
            }
            
            self.passwordTextField.text = nil
            self.emailTextField.text = nil
            
            let collectionListViewController = UIStoryboard.collectionListViewController
            self.navigationController?.pushViewController(collectionListViewController, animated: true)
            
        }.ensure {
            
            self.isLoading = false
            
        }.catch { error in
            
            let alert = UIAlertController(error: error)
            self.present(alert, animated: true)
            
        }
        
    }
    
}
