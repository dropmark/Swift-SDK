//
//  ContainerViewController.swift
//  macOS Demo
//
//  Created by Alex Givens on 9/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Cocoa

class ContainerViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let loginViewController = NSStoryboard.loginViewController
        insertChildViewController(loginViewController, at: 0)
        view.addSubview(loginViewController.view)
        view.frame = loginViewController.view.frame
        
    }
    
}
