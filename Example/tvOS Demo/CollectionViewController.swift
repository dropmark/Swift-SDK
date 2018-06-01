//
//  CollectionViewController.swift
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

class CollectionViewController: UITableViewController {
    
    var collection: DMCollection!
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = collection.name
        
        firstly {
            RequestGenerator.listItemsIn(collection: collection)
            }.done {
                self.items = $0
                self.tableView.reloadData()
            }.catch { error in
                self.showOKAlertWithTitle("An error occurred", message: error.localizedDescription)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.dropmark.cell.item", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        switch item.type {
            
        case .stack:
            let itemCount = item.itemsTotalCount ?? 0
            cell.detailTextLabel?.text = "\(item.type.title) - \(itemCount) items"
            
        default:
            cell.detailTextLabel?.text = item.type.title
            
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        switch item.type {
            
        case .stack:
            performSegue(withIdentifier: "showStackViewControllerFromCollectionViewController", sender: self)
            
        default:
            performSegue(withIdentifier: "showItemViewControllerFromCollectionViewController", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        if
            segue.identifier == "showStackViewControllerFromCollectionViewController",
            let stackViewController = segue.destination as? StackViewController
        {
            stackViewController.collection = collection
            stackViewController.stack = items[indexPath.row]
            
        } else if
            segue.identifier == "showItemViewControllerFromCollectionViewController",
            let itemViewController = segue.destination as? ItemViewController
        {
            itemViewController.item = items[indexPath.row]
        }
        
        
    }
    
    
}
