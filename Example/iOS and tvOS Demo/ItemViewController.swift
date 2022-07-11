//
//  ItemViewController.swift
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

import UIKit
import Alamofire
import DropmarkSDK

class ItemViewController: UIViewController {
    
    var item: DKItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
#if os(iOS)
    
    @IBOutlet weak var dropmarkLinkButton: UIButton!
    @IBOutlet weak var sourceLinkButton: UIButton!
    
#elseif os(tvOS)
    
    @IBOutlet weak var dromparkLinkLabel: UILabel!
    @IBOutlet weak var sourceLinkLabel: UILabel!
    
#endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = item.name
        
        // TODO: Thumbnails
        if let thumbnailURL = item.thumbnails?.cropped { // Load thumbnail
            
            Alamofire.request(thumbnailURL).responseData { response in
                guard let data = response.data, let image = UIImage(data: data) else { return }
                self.imageView.image = image
            }
            
        } else if item.type == .text, let text = item.content as? String { // Show text view for text items
            
            textView.text = text
            textView.isHidden = false
            
        }
        
#if os(iOS)
        
        dropmarkLinkButton.setTitle(item.url.absoluteString, for: .normal)
        sourceLinkButton.setTitle(item.link?.absoluteString, for: .normal)
        
#elseif os(tvOS)
        
        dromparkLinkLabel.text = item.url.absoluteString
        sourceLinkLabel.text = item.link?.absoluteString
        
#endif
        
    }
    
#if os(iOS)
    
    @IBAction func didPressDropmarkLinkButton(_ sender: Any) {
        UIApplication.shared.open(item.url)
    }
    
    @IBAction func didPressSourceLinkButton(_ sender: Any) {
        if let link = item.link {
            UIApplication.shared.open(link)
        }
    }

#endif
    
}
