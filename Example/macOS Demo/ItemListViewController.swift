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


import Cocoa
import AppKit
import Alamofire
import AlamofireImage
import PromiseKit
import DropmarkSDK

class ItemListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    let itemCell = "com.dropmark.cell.collection"
    
    var collection: DKCollection!
    var stack: DKItem?
    
    let paging = DKPagingGenerator<DKItem>(startPage: 1)
    var items = [DKItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stackName = stack?.name {
            title = stackName
        } else {
            title = collection.name
        }
        
        paging.next = { page in
            return RequestGenerator.listItems(collection: self.collection, stack: self.stack, page: page)
        }
        
        getNextPageOfItems().catch { error in
            NSAlert.showAlert(for: error)
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
    
    // MARK: NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let identifier = NSUserInterfaceItemIdentifier(rawValue: itemCell)
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView else {
            fatalError("Unable to generate a NSTableViewCell")
        }
        
        let item = items[row]
        
        if let itemName = item.name {
            cell.textField?.stringValue = itemName
        }
        
        if let thumbnailURL = item.thumbnails?.cropped {
            Alamofire.request(thumbnailURL).responseImage { response in
                if let image = response.result.value {
                    cell.imageView?.image = image
                }
            }
        }
        
        return cell
        
    }
    
    // MARK: NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
}
