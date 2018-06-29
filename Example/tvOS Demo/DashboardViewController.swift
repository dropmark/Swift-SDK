//
//  DashboardViewController.swift
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

import UIKit
import PromiseKit
import DropmarkSDK

class DashboardViewController: UITableViewController {
    
    var collections = [DKCollection]()
    
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
        DKKeychain.user = nil
        DKRouter.user = nil
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
