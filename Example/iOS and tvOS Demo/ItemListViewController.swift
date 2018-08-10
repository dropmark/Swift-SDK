//
//  ItemListViewController.swift
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
import AlamofireImage
import PromiseKit
import DropmarkSDK

class ItemListViewController: UITableViewController {
    
    let itemCellIdentifier = "com.dropmark.cell.item"
    
    /// Parent collection of the item list
    var collection: DKCollection!
    
    /// Parent stack of the item list
    var stack: DKItem?
    
    var paging = DKPagingGenerator<DKItem>(startPage: 1)
    
    var items = [DKItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stackName = stack?.name {
            title = stackName
        } else {
            title = collection.name
        }
        
#if os(iOS)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
#endif
        
        paging.next = { page in
            return PromiseGenerator.listItems(collection: self.collection, stack: self.stack, page: page)
        }
        
        getNextPageOfItems().catch { error in
            let alert = UIAlertController(error: error, preferredStyle: .alert)
            self.present(alert, animated: true)
        }
        
    }
    
    @discardableResult func getNextPageOfItems() -> Promise<Void> {
        return paging.getNext().done {
            self.items.insert(contentsOf: $0, at: self.items.endIndex)
        }
    }
    
    // MARK: Refresh
    
    @discardableResult func refresh() -> Promise<Void> {
        paging.reset()
        items.removeAll()
        return getNextPageOfItems()
    }
    
#if os(iOS)
    
    @objc func pullToRefresh(refreshControl: UIRefreshControl) {
        
        firstly {
            refresh()
        }.ensure {
            refreshControl.endRefreshing()
        }.catch { error in
            let alert = UIAlertController(error: error, preferredStyle: .alert)
            self.present(alert, animated: true)
        }
        
    }
    
#endif
    
}

// MARK: - UITableViewDataSource

extension ItemListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath)
        
        let item = items[indexPath.row]
        
        // Title
        cell.textLabel?.text = item.name
        
        switch item.type {
            
        case .stack:
            
            // Subtitle
            let itemCount = item.itemsTotalCount ?? 0
            cell.detailTextLabel?.text = "Stack - \(itemCount) items"
            
            // Accessory
            cell.accessoryType = .disclosureIndicator
            
        default:
            
            // Subtitle
            cell.detailTextLabel?.text = item.type.rawValue.capitalized
            
            // Accessory
            cell.accessoryType = .none
            
        }
        
        // Image
        cell.imageView?.image = #imageLiteral(resourceName: "Thumbnail Placeholder")
        if let thumbnailURL = item.thumbnails?.cropped {
            cell.imageView?.af_setImage(withURL: thumbnailURL)
        }
        
        return cell
        
    }
    
}

// MARK: - UITableViewDelegate

extension ItemListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        switch item.type {
            
        case .stack:
            let itemListViewController = UIStoryboard.itemListViewController
            itemListViewController.collection = collection
            itemListViewController.stack = item
            navigationController?.pushViewController(itemListViewController, animated: true)
            
        default:
            let itemViewController = UIStoryboard.itemViewController
            itemViewController.item = item
            navigationController?.pushViewController(itemViewController, animated: true)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // If the user scrolled to the end
        if paging.shouldGetNextPage(at: indexPath, for: tableView) {
            
            // Get the next page of collections
            getNextPageOfItems().catch { error in
                let alert = UIAlertController(error: error, preferredStyle: .alert)
                self.present(alert, animated: true)
            }
            
        }
        
    }
    
}
