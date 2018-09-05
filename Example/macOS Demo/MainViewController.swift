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


import Cocoa
import AppKit
import Alamofire
import AlamofireImage
import PromiseKit
import DropmarkSDK

enum PagingError: Error {
    case noCollectionProvided
    case noStackProvided
}

class MainViewController: NSViewController {
    
    var selectedCollection: DKCollection?
    var selectedStack: DKItem?
    
    @IBOutlet weak var collectionsTableView: NSTableView!
    let collectionsPaging = DKPagingGenerator<DKCollection>(startPage: 1)
    var collections = [DKCollection]() {
        didSet {
            collectionsTableView.reloadData()
        }
    }
    
    @IBOutlet weak var primaryItemsTableView: NSTableView!
    let primaryItemsPaging = DKPagingGenerator<DKItem>(startPage: 1)
    var primaryItems = [DKItem]() {
        didSet {
            primaryItemsTableView.reloadData()
        }
    }
    
    @IBOutlet weak var secondaryItemsTableView: NSTableView!
    let secondaryItemsPaging = DKPagingGenerator<DKItem>(startPage: 1)
    var secondaryItems = [DKItem]() {
        didSet {
            secondaryItemsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionsPaging.next = { PromiseGenerator.listCollections(page: $0) }
        
        primaryItemsPaging.next = { page in
            guard let collection = self.selectedCollection else {
                return Promise(error: PagingError.noCollectionProvided)
            }
            return PromiseGenerator.listItems(collection: collection, stack: nil, page: page)
        }
        
        secondaryItemsPaging.next = { page in
            guard let collection = self.selectedCollection else {
                return Promise(error: PagingError.noCollectionProvided)
            }
            guard let stack = self.selectedStack else {
                return Promise(error: PagingError.noStackProvided)
            }
            return PromiseGenerator.listItems(collection: collection, stack: stack, page: page)
        }
        
        getNextPageOfCollections().catch { error in
            NSAlert.showOKAlert(error: error)
        }
        
    }
    
    @discardableResult func getNextPageOfCollections() -> Promise<Void> {
        return collectionsPaging.getNext().done {
            self.collections.insert(contentsOf: $0, at: self.collections.endIndex)
        }
    }
    
    @discardableResult func getNextPageOfPrimaryItems() -> Promise<Void> {
        return primaryItemsPaging.getNext().done {
            self.primaryItems.insert(contentsOf: $0, at: self.primaryItems.endIndex)
        }
    }
    
    @discardableResult func getNextPageOfSecondaryItems() -> Promise<Void> {
        return secondaryItemsPaging.getNext().done {
            self.secondaryItems.insert(contentsOf: $0, at: self.secondaryItems.endIndex)
        }
    }
    
    @IBAction func didClickLogoutButton(_ sender: Any) {
        DKKeychain.user = nil
        DKRouter.user = nil
        performSegue(withIdentifier: NSStoryboardSegue.Identifier.showLoginViewController, sender: nil)
    }
    
    @IBAction func didClickRefreshButton(_ sender: Any) {
        resetCollections()
        resetPrimaryItems()
        resetSecondaryItems()
        getNextPageOfCollections().catch { error in
            NSAlert.showOKAlert(error: error)
        }
    }
    
    // MARK: Refresh
    
    func resetCollections() {
        selectedCollection = nil
        selectedStack = nil
        collectionsPaging.reset()
        collections.removeAll()
    }
    
    func resetPrimaryItems() {
        selectedCollection = nil
        selectedStack = nil
        primaryItemsPaging.reset()
        primaryItems.removeAll()
    }
    
    func resetSecondaryItems() {
        selectedStack = nil
        secondaryItemsPaging.reset()
        secondaryItems.removeAll()
    }

}

extension MainViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int) {
        
        if tableView == collectionsTableView {
            
            if collectionsPaging.shouldGetNextPage(at: row, for: tableView) {
                getNextPageOfCollections()
            }
            
        } else if tableView == primaryItemsTableView {
            
            if primaryItemsPaging.shouldGetNextPage(at: row, for: tableView) {
                getNextPageOfPrimaryItems()
            }
            
        } else if tableView == secondaryItemsTableView {
            
            if secondaryItemsPaging.shouldGetNextPage(at: row, for: tableView) {
                getNextPageOfSecondaryItems()
            }
            
        }
        
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        if tableView == collectionsTableView {
            
            resetPrimaryItems()
            resetSecondaryItems()
            selectedCollection = collections[row]
            getNextPageOfPrimaryItems()
            
        } else if tableView == primaryItemsTableView {
            
            resetSecondaryItems()
            let item = primaryItems[row]
            if item.type == .stack {
                selectedStack = item
                getNextPageOfSecondaryItems()
            }
            
        } else if tableView == secondaryItemsTableView {
            
        }
        
        return true
        
    }
    
}

extension MainViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == collectionsTableView {
            return collections.count
        } else if tableView == primaryItemsTableView {
            return primaryItems.count
        } else if tableView == secondaryItemsTableView {
            return secondaryItems.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if tableView == collectionsTableView {
            
            let collection = collections[row]
            return collection.name
            
        } else if tableView == primaryItemsTableView {
            
            let item = primaryItems[row]
            return item.name
            
        } else if tableView == secondaryItemsTableView {
            
            let item = secondaryItems[row]
            return item.name
            
        } else {
            
            return nil
            
        }
        
    }
    
}
