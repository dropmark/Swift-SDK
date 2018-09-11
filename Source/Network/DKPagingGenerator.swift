//
//  DKPagingGenerator.swift
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

import Foundation
import Alamofire
import PromiseKit

/// Use this class to load consecutive "pages" of content from a listable API endpoint. Includes utilities to check for new content while scrolling in a UICollectionView, UITableView, NSCollectionView, or NSTableView.
public class DKPagingGenerator<T> {
    
    /**
     Required - Set this closure to process a single page of results, and return your request packaged in a CancellablePromiseKit promise. A single page is requested and returned in the promise format. By calling `getNext()`, this closure will be used.
     */
    public var next: ((_ page: Int) -> CancellablePromise<[T]>)!
    
    /// The current page
    public var page: Int
    
    /// The number of items in a single page request. This integer is used to calculate when a list endpoint reaches the end.
    public var pageSize: Int = DKRouter.pageSize
    
    /// The first page to start paginating from. Defaults to 1.
    private var startPage: Int = 1
    
    /// Test if pagination loaded all objects from the list.
    public var didReachEnd: Bool = false
    
    /// Test if pagination is in the process of retrieving a page.
//    public var isFetchingPage: Bool = false
    public var isFetchingPage: Bool {
        return currentChain?.isPending ?? false
    }
    
    internal var currentChain: CancellablePromise<[T]>?
    
    /**
     
     Initialize a pagination object, beginning with the specified `startPage`. `DKPaginationGenerator` retrieves items of a generic Type, so a placeholder Type is required to specify what kinds of objects will be paginated and returned.
     
     - Parameters:
         - startPage: An integer specifying which page to begin paginating from
 
     */
    public init(startPage: Int) {
        self.startPage = startPage
        self.page = startPage
    }
    
    deinit {
        next = nil
    }
    
    /// Get the next page of results as outlined in the `next` closure.
    public func getNext() -> CancellablePromise<[T]> {
        
        guard didReachEnd == false else {
            let emptyArray = [T]()
            return Promise.value(emptyArray).asCancellable()
        }
        
        let chain: CancellablePromise<[T]> = next(page).then { [weak self] objects in
            self?.page += 1
            if let pageSize = self?.pageSize, objects.count < pageSize {
                self?.didReachEnd = true
            }
            return Promise.value(objects).asCancellable()
        }
        
        currentChain = chain
        
        return chain
        
    }
    
    /// Cancel the current pagination request, if one exists
    func cancel() {
        currentChain?.cancel()
    }
    
    /// Cancel the current pagination request, if one exists, then reset pagination back to the original `startPage`
    public func reset() {
        cancel()
        didReachEnd = false
        page = startPage
    }
    
}

// MARK: Infinite scroll utilities

public extension DKPagingGenerator {
    
#if os(iOS) || os(tvOS)
    
    /**
     
     Trigger utility to determine if a user scrolled to the end of a `UICollectionView`. We recommend using this function in your `UICollectionViewDelegate` `collectionView(_:willDisplay:forItemAt:)` method to determine if you should call your `getNext()` promise.
     
     - Parameters:
         - indexPath: The indexPath at which to check if pagination should be triggered
         - collectionView: The UICollectionView to check for pagination
     
     */
    public func shouldGetNextPage(at indexPath: IndexPath, for collectionView: UICollectionView) -> Bool {
        if let cellCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section) {
            return shouldGetNextPage(at: indexPath.item, for: cellCount)
        }
        return false
    }
    
    /**
     
     Trigger utility to determine if a user scrolled to the end of a `UITableView`. We recommend using this function in your `UITableViewDelegate` `tableView(_:willDisplay:forRowAt:)` method to determine if you should call your `getNext()` promise.
     
     - Parameters:
        - indexPath: The indexPath at which to check if pagination should be triggered
        - tableView: The UITableView to check for pagination
     
     */
    public func shouldGetNextPage(at indexPath: IndexPath, for tableView: UITableView) -> Bool {
        if let cellCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) {
            return shouldGetNextPage(at: indexPath.row, for: cellCount)
        }
        return false
    }
    
#elseif os(macOS)
    
    /**
     
     Trigger utility to determine if a user scrolled to the end of a `NSCollectionView`. We recommend using this function in your `UICollectionViewDelegate` `collectionView(_:willDisplay:forRepresentedObjectAt:)` method to determine if you should call your `getNext()` promise.
     
     - Parameters:
        - indexPath: The indexPath at which to check if pagination should be triggered
        - collectionView: The UITableView to check for pagination
     
     */
    public func shouldGetNextPage(at indexPath: IndexPath, for collectionView: NSCollectionView) -> Bool {
        if let cellCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section) {
            return shouldGetNextPage(at: indexPath.item, for: cellCount)
        }
        return false
    }

    /**
     
     Trigger utility to determine if a user scrolled to the end of a `NSTableView`. We recommend using this function in your `NSTableViewDelegate` `tableView(_:willDisplayCell:for:row:)` method to determine if you should call your `getNext()` promise.
     
     - Parameters:
        - indexPath: The indexPath at which to check if pagination should be triggered
        - tableView: The NSTableView to check for pagination
     
     */
    public func shouldGetNextPage(at row: Int, for tableView: NSTableView) -> Bool {
        if let cellCount = tableView.dataSource?.numberOfRows?(in: tableView) {
            return shouldGetNextPage(at: row, for: cellCount)
        }
        return false
    }
    
#endif
    
    /**
     
     Private utility to determing if an index in a list view should trigger the next page.
     
     - Parameters:
         - index: The index at which to check if pagination should trigger
         - cellCount: The total number of cells in the list view
     
     */
    private func shouldGetNextPage(at index: Int, for cellCount: Int) -> Bool {
        
        if
            cellCount > 0, // If at least 1 item is loaded ...
            index >= cellCount - 1, // ... and the user scrolled to the last cell ...
            didReachEnd == false // ... and there are still items to fetch.
        {
            return true
        }
        
        return false
        
    }
    
}
