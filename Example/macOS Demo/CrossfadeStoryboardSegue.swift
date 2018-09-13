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
//  Source: http://theiconmaster.com/2015/03/transitioning-between-view-controllers-in-the-same-window-with-swift-mac/

import Cocoa

class CrossfadeStoryboardSegue: NSStoryboardSegue {
    
    override func perform() {
        
        // build from-to and parent-child view controller relationships
        let sourceViewController  = self.sourceController as! NSViewController
        let destinationViewController = self.destinationController as! NSViewController
        let containerViewController = sourceViewController.parent! as NSViewController
        
        // add destinationViewController as child
        containerViewController.insertChild(destinationViewController, at: 1)
        
        // get the size of destinationViewController
        let targetSize = destinationViewController.view.frame.size
        let targetWidth = destinationViewController.view.frame.size.width
        let targetHeight = destinationViewController.view.frame.size.height
        
        // prepare for animation
        sourceViewController.view.wantsLayer = true
        destinationViewController.view.wantsLayer = true
        
        //perform transition
        containerViewController.transition(from: sourceViewController, to: destinationViewController, options: .crossfade, completionHandler: nil)
        
        //resize view controllers
        sourceViewController.view.animator().setFrameSize(targetSize)
        destinationViewController.view.animator().setFrameSize(targetSize)
        
        //resize and shift window
        let currentFrame = containerViewController.view.window?.frame
        let currentRect = NSRectToCGRect(currentFrame!)
        let horizontalChange = (targetWidth - containerViewController.view.frame.size.width)/2
        let verticalChange = (targetHeight - containerViewController.view.frame.size.height)/2
        let newWindowRect = NSMakeRect(currentRect.origin.x - horizontalChange, currentRect.origin.y - verticalChange, targetWidth, targetHeight)
        containerViewController.view.window?.setFrame(newWindowRect, display: true, animate: true)
        
        // lose the sourceViewController, it's no longer visible
        containerViewController.removeChild(at: 0)
    }
    
    
}
