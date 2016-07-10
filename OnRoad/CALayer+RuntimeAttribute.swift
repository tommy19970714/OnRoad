//
//  CALayer+RuntimeAttribute.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/10.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

extension CALayer {
    
    func setBorderIBColor(color: UIColor!) -> Void{
        self.borderColor = color.CGColor
    }
}