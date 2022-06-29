//
//  ColorAttributeTransformer.swift
//  Pods
//
//  Created by Alex Givens on 6/28/22.
//

#if os(iOS) || os(tvOS)

import UIKit

public class ColorAttributeTransformer: NSSecureUnarchiveFromDataTransformer {

    public override static var allowedTopLevelClasses: [AnyClass] {
        [UIColor.self]
    }

    static func register() {
        let className = String(describing: ColorAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = ColorAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
}

#endif
