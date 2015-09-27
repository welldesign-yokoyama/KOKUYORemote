//
//  CustomButton.swift
//  KOKUYORemore
//
//  Created by well on 9/21/15.
//  Copyright © 2015 welldesign. All rights reserved.
//

import UIKit

@IBDesignable

/**
 CustomButton Class
 **/
class CustomButton: UIButton {

    //@IBInspectable var textColor: UIColor?
    @IBInspectable var defaultBackgroundColor :UIColor?
    @IBInspectable var selectedBackgroundColor :UIColor?
    @IBInspectable var highlightedBackgroundColor :UIColor?
    
    /**
     Corner Radius
     **/
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    /**
     Border Width
     **/
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /**
     Border Color
     **/
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    /**
     State Highlighted
     **/
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
    
    /**
     State Selected
     **/
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
