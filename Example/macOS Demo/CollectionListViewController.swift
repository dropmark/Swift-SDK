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

class CollectionListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    let collectionCell = "com.dropmark.cell.collection"
    
    let paging = DKPagingGenerator<DKCollection>(startPage: 1)
    var collections = [DKCollection]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paging.next = { page in
            return PromiseGenerator.listCollections(page: page)
        }
        
        getNextPageOfCollections().catch { error in
            NSAlert.showAlert(for: error)
        }
        
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
    
    // MARK: NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let identifier = NSUserInterfaceItemIdentifier(rawValue: collectionCell)
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView else {
            fatalError("Unable to generate a NSTableViewCell")
        }
        
        let collection = collections[row]
        
        cell.textField?.stringValue = collection.name
        
        if let thumbnailURL = collection.thumbnails?.cropped {
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
        return collections.count
    }
    
}
