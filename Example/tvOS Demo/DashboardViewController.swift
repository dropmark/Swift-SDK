//
//  DashboardViewController.swift
//  tvOS Demo
//
//  Created by Alexander Givens on 5/31/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import PromiseKit
import DropmarkSDK

class DashboardViewController: UITableViewController {
    
    var collections = [DMCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didPressLogoutButton))
        navigationItem.leftBarButtonItem = logoutButton
        
        firstly {
            RequestGenerator.listCollections()
            }.done {
                self.collections = $0
                self.tableView.reloadData()
            }.catch { error in
                self.showOKAlertWithTitle("An error occurred", message: error.localizedDescription)
        }
        
    }
    
    @objc func didPressLogoutButton() {
        Keychain.user = nil
        Router.user = nil
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.dropmark.cell.collection", for: indexPath)
        
        let collection = collections[indexPath.row]
        
        cell.textLabel?.text = collection.name
        
        let itemCount = collection.itemsTotalCount ?? 0
        cell.detailTextLabel?.text = "\(itemCount) items"
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if
            segue.identifier == "showCollectionViewControllerFromDashboardViewController",
            let indexPath = tableView.indexPathForSelectedRow,
            let collectionViewController = segue.destination as? CollectionViewController
        {
            collectionViewController.collection = collections[indexPath.row]
        }
        
    }
    
}
