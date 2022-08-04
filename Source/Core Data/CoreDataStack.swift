//
//  CoreDataStack.swift
//
//  Copyright © 2022 Oak, LLC (https://oak.is)
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
import CoreData

public class CoreDataStack {

    static public let shared = CoreDataStack()
    public var errorHandler: (Error) -> Void = {_ in }
    
    public static let modelName = "Dropmark"
    
    lazy public var model: NSManagedObjectModel = {

        var rawBundle: Bundle? {

            if let bundle = Bundle(identifier: "org.cocoapods.DropmarkSDK") {
                return bundle
            }

            guard
                let resourceBundleURL = Bundle(for: type(of: self)).url(forResource: "DropmarkSDK", withExtension: "bundle"),
                let realBundle = Bundle(url: resourceBundleURL)
            else {
                return nil
            }

            return realBundle
        }

        guard let bundle = rawBundle else {
            print("Could not get bundle that contains the model ")
            return NSManagedObjectModel()
        }

        guard
            let modelURL = bundle.url(forResource: "Dropmark", withExtension: "momd")
        else {
            print("Could not get bundle for managed object model")
            return NSManagedObjectModel()
        }

        return NSManagedObjectModel(contentsOf: modelURL) ?? NSManagedObjectModel()
    }()

    lazy public var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: model)
        container.loadPersistentStores { [weak self] storeDescription, error in
            guard let error = error as? NSError else { return }
            print("Core Data error \(error), \(error.userInfo)")
            self?.errorHandler(error)
        }
        return container
    }()
    
    lazy public var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy public var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }
    
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
}

// https://www.raywenderlich.com/books/core-data-by-tutorials/v8.0/chapters/7-unit-testing

//class TestCoreDataStack: CoreDataStack {
//
//    override init() {
//        super.init()
//
//        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: model)
//        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
//
//        container.loadPersistentStores { _, error in
//            if let error = error as NSError? {
//            fatalError(
//            "Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//
//        self.storeContainer = container
//    }
//}
