//
//  CollectionListViewController.swift
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
import AlamofireImage
import DropmarkSDK

class CollectionListViewController: UITableViewController {
    
    let collectionCell = "com.dropmark.cell.collection"
    
    let paging = DKPagingGenerator<DKCollection>(startPage: 1)
    var collections = [DKCollection]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didPressLogoutButton))
        navigationItem.leftBarButtonItem = logoutButton
        
#if os(iOS)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
#endif
        
        paging.next = { page in
            return RequestGenerator.listCollections(page: page)
        }
        
        getNextPageOfCollections().catch { error in
            let alert = UIAlertController(error: error, preferredStyle: .alert)
            self.present(alert, animated: true)
        }
        
    }
    
    @objc func didPressLogoutButton() {
        DKKeychain.user = nil
        DKRouter.user = nil
        navigationController?.popToRootViewController(animated: true)
    }
    
    @discardableResult func getNextPageOfCollections() -> Promise<Void> {
        return paging.getNext().done {
            self.collections.insert(contentsOf: $0, at: self.collections.endIndex)
        }
    }
    
    // MARK: Refresh
    
    @discardableResult func refresh() -> Promise<Void> {
        paging.reset()
        collections.removeAll()
        return getNextPageOfCollections()
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
    
    // MARK: Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: collectionCell, for: indexPath)
        
        let collection = collections[indexPath.row]
        
        cell.textLabel?.text = collection.name
        let itemCount = collection.itemsTotalCount ?? 0
        cell.detailTextLabel?.text = "\(itemCount) items"
        
        cell.imageView?.image = #imageLiteral(resourceName: "Thumbnail Placeholder")
        if let thumbnailURL = collection.thumbnails?.cropped {
            cell.imageView?.af_setImage(withURL: thumbnailURL)
        }
        
        return cell
        
    }
    
    // MARK: Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.imageView?.contentMode = .scaleAspectFit
        
        // If the user scrolled to the end
        if paging.shouldGetNextPage(at: indexPath, for: tableView) {
            
            // Get the next page of collections
            getNextPageOfCollections().catch { error in
                let alert = UIAlertController(error: error, preferredStyle: .alert)
                self.present(alert, animated: true)
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemListViewController = UIStoryboard.itemListViewController
        itemListViewController.collection = collections[indexPath.row]
        navigationController?.pushViewController(itemListViewController, animated: true)
        
    }
    
}
