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

/**
 
 Use the paging generator to load consecutive pages of content from a listable API endpoint. Includes utilities for UITableView, UICollectionView, and NSTableView.
 
 */

public class DKPagingGenerator<T> {
    
    public var next: ((_ page: Int) -> Promise<[T]>)!
    
    public var page: Int
    public var pageSize: Int = 24
    private var startPage: Int = 1
    public var didReachEnd: Bool = false
    public var isFetchingPage: Bool = false
    
    public init(startPage: Int) {
        self.startPage = startPage
        self.page = startPage
    }
    
    deinit {
        next = nil
    }
    
    public func getNext() -> Promise<[T]> {
        
        return Promise { seal in
            
            guard didReachEnd == false else {
                seal.reject(PaginationError.didReachEnd)
                return
            }
            
            guard isFetchingPage == false else {
                seal.reject(PaginationError.isFetchingPage)
                return
            }
            
            isFetchingPage = true
            
            firstly {
                self.next(page)
            }.done { [weak self] objects in
                self?.page += 1
                if let pageSize = self?.pageSize, objects.count < pageSize {
                    self?.didReachEnd = true
                }
                seal.fulfill(objects)
            }.ensure { [weak self] in
                self?.isFetchingPage = false
            }.catch { error in
                seal.reject(error)
            }
            
        }
        
    }
    
    public func reset() {
        didReachEnd = false
        page = startPage
    }
    
}

// MARK: Infinite scroll utilities

public extension DKPagingGenerator {
    
#if os(iOS) || os(tvOS)
    
    public func shouldGetNextPage(at indexPath: IndexPath, for collectionView: UICollectionView) -> Bool {
        if let cellCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section) {
            return shouldGetNextPage(at: indexPath, for: cellCount)
        }
        return false
    }
    
    public func shouldGetNextPage(at indexPath: IndexPath, for tableView: UITableView) -> Bool {
        if let cellCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) {
            return shouldGetNextPage(at: indexPath, for: cellCount)
        }
        return false
    }
    
#endif
    
    #if os(macOS)
//    public func shouldGetNextPage(at indexPath: IndexPath, for collectionView: NSCollectionView) -> Bool {
//        if let cellCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section) {
//            return shouldGetNextPage(at: indexPath, for: cellCount)
//        }
//        return false
//    }
//
//    public func shouldGetNextPage(at indexPath: IndexPath, for tableView: UITableView) -> Bool {
//        if let cellCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) {
//            return shouldGetNextPage(at: indexPath, for: cellCount)
//        }
//        return false
//    }
    #endif
    
    private func shouldGetNextPage(at indexPath: IndexPath, for cellCount: Int) -> Bool {
        
        if
            cellCount > 0, // If at least 1 item is loaded ...
            indexPath.item >= cellCount - 1, // ... and the user scrolled to the last cell ...
            didReachEnd == false // ... and there are still items to fetch.
        {
            return true
        }
        return false
        
    }
    
}
