//
//  AppDelegate.swift
//
//  Copyright © 2020 Oak, LLC (https://oak.is)
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
import DropmarkSDK

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        DKKeychain.service = "Dropmark SDK Demo"
        
        NSDictionaryAttributeTransformer.register()
        
        // Save test bow tie
        let item = NSEntityDescription.insertNewObject(forEntityName: "DMItem", into: CoreDataStack.shared.persistentContainer.viewContext) as! DMItem
        item.name = "My bow tie"
        item.createdAt = Date()
        CoreDataStack.shared.saveContext()

        // Retrieve test bow tie
        let request: NSFetchRequest<DMItem> = DMItem.fetchRequest()

        if
            let items = try? CoreDataStack.shared.viewContext.fetch(request),
            let testName = items.first?.name,
            let testCreatedAt = items.first?.createdAt
        {
            print("Name: \(testName), Created At: \(testCreatedAt)")
        } else {
            print("Test failed.")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

