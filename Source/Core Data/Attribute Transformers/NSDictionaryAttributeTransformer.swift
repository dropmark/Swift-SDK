//
//  NSDictionaryAttributeTransformer.swift
//  Pods
//
//  Created by Alex Givens on 6/28/22.
//

import Foundation

class NSDictionaryAttributeTransformer: NSSecureUnarchiveFromDataTransformer {

    override static var allowedTopLevelClasses: [AnyClass] {
        [NSDictionary.self]
        
    }

    static func register() {
        let className = String(describing: NSDictionaryAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = NSDictionaryAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
}
