//
//  NavigationViewController.swift
//  macOS Demo
//
//  Created by Alex Givens on 8/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Cocoa
import DropmarkSDK

class NavigationViewController: NSViewController {
    
    var collections = [DKCollection]()
    var primaryItems = [DKItem]()
    var secondaryItems = [DKItem]()
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
}

extension NavigationViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let CollectionCell = "CollectionCell"
        static let ItemCell = "ItemCell"
    }
    
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
    
}

extension NavigationViewController: NSTableViewDataSource {
    
}
