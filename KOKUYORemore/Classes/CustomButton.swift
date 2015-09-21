//
//  CustomButton.swift
//  KOKUYORemore
//
//  Created by well on 9/21/15.
//  Copyright © 2015 welldesign. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var defaultBackgroundColor :UIColor?
    @IBInspectable var selectedBackgroundColor :UIColor?
    @IBInspectable var highlightedBackgroundColor :UIColor?
    
    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    override var highlighted :Bool {
        didSet {
            if highlighted {
                self.backgroundColor = highlightedBackgroundColor
            }
            else {
                self.backgroundColor = defaultBackgroundColor
            }
        }
    }
    
    override var selected :Bool {
        didSet {
            if selected {
                self.backgroundColor = selectedBackgroundColor
            }
            else {
                self.backgroundColor = defaultBackgroundColor
            }
        }
    }
}
