//
//  UIStoryboard+Extensions.swift
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

extension UIStoryboard {
    
    static let collectionListViewControllerIdentifier = "CollectionListViewControllerIdentifier"
    static let itemListViewControllerIdentifier = "ItemListViewControllerIdentifier"
    static let itemViewControllerIdentifier = "ItemViewControllerIdentifier"
    
    private class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class var collectionListViewController: CollectionListViewController {
        guard let collectionListViewController = main.instantiateViewController(withIdentifier: collectionListViewControllerIdentifier) as? CollectionListViewController else {
            fatalError("Unable to instantiate a CollectionListViewController.")
        }
        return collectionListViewController
    }
    
    class var itemListViewController: ItemListViewController {
        guard let itemListViewController = main.instantiateViewController(withIdentifier: itemListViewControllerIdentifier) as? ItemListViewController else {
            fatalError("Unable to instantiate an ItemListViewController.")
        }
        return itemListViewController
    }
    
    class var itemViewController: ItemViewController {
        guard let itemViewController = main.instantiateViewController(withIdentifier: itemViewControllerIdentifier) as? ItemViewController else {
            fatalError("Unable to instantiate an ItemViewController.")
        }
        return itemViewController
    }
    
}
