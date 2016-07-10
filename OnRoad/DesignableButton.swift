//
//  DesignableButton.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/10.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 3.0
    
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = Color.green
    
    
    override func drawRect(rect: CGRect) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = (cornerRadius > 0)
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
    }
}