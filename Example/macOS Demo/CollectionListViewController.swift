//
//  NavigationViewController.swift
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
            return RequestGenerator.listCollections(page: page)
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
//        if let thumbnailURL = collection.thumbnails?.cropped {
//            cell.imageView?.af_setImage(withURL: thumbnailURL)
//        }
        
        return cell
        
    }
    
    // MARK: NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return collections.count
    }
    
}

//extension CollectionListViewController: NSTableViewDelegate {
//
//
//
//    fileprivate enum CellIdentifiers {
//        static let CollectionCell = "CollectionCell"
//        static let ItemCell = "ItemCell"
//    }
//
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        
//        var image: NSImage?
//        var text: String = ""
//        var cellIdentifier: String = ""
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .long
//        
//        // 1
//        guard let item = directoryItems?[row] else {
//            return nil
//        }
//        
//        // 2
//        if tableColumn == tableView.tableColumns[0] {
//            image = item.icon
//            text = item.name
//            cellIdentifier = CellIdentifiers.NameCell
//        } else if tableColumn == tableView.tableColumns[1] {
//            text = dateFormatter.string(from: item.date)
//            cellIdentifier = CellIdentifiers.DateCell
//        } else if tableColumn == tableView.tableColumns[2] {
//            text = item.isFolder ? "--" : sizeFormatter.string(fromByteCount: item.size)
//            cellIdentifier = CellIdentifiers.SizeCell
//        }
//        
//        // 3
//        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
//            cell.textField?.stringValue = text
//            cell.imageView?.image = image ?? nil
//            return cell
//        }
//        return nil
//        
//    }
//
//}

