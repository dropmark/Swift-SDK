//
//  NSStoryboard+Extensions.swift
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

extension NSStoryboardSegue.Identifier {
    static let showMainViewController = "ShowMainViewControllerSegueIdentifier"
    static let showLoginViewController = "ShowLoginViewControllerSegueIdentifier"
}

extension NSStoryboard {
    
    static let containerViewControllerIdentifier    = "ContainerViewControllerIdentifier"
    static let loginViewControllerIdentifier        = "LoginViewControllerIdentifier"
    static let mainViewControllerIdentifier         = "MainViewControllerIdentifier"
    
    private class var main: NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }
    
    class var containerViewController: NSViewController {
        guard let containerViewController = NSStoryboard.main.instantiateController(withIdentifier: containerViewControllerIdentifier) as? NSViewController else {
            fatalError("Unable to instantiate the container view controller.")
        }
        return containerViewController
    }
    
    class var loginViewController: LoginViewController {
        guard let loginViewController = NSStoryboard.main.instantiateController(withIdentifier: loginViewControllerIdentifier) as? LoginViewController else {
            fatalError("Unable to instantiate a LoginViewController.")
        }
        return loginViewController
    }
    
    class var mainViewController: MainViewController {
        guard let mainViewController = NSStoryboard.main.instantiateController(withIdentifier: mainViewControllerIdentifier) as? MainViewController else {
            fatalError("Unable to instantiate an MainViewController.")
        }
        return mainViewController
    }
    
    
}

