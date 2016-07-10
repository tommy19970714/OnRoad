//
//  CustomUIButton.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/05.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation

class CustomUIButton: UIButton {
    private var sw:Bool = false
    private let offalpha:CGFloat = 1
    internal var imageName:String?
    
    func setIcon(imageName:String)
    {
        self.imageName = imageName
        self.alpha = offalpha
        self.setImage(UIImage(named: imageName + "_off"), forState: .Normal)
    }
    
    func getSw()->Bool{
        return sw
    }
    func changeSw()
    {
        if sw == false
        {
            self.alpha = 1.0
            sw = true
            self.setImage(UIImage(named: imageName! + "_on"), forState: .Normal)
        }
        else
        {
            self.alpha = offalpha
            sw = false
            self.setImage(UIImage(named: imageName! + "_off"), forState: .Normal)
        }
    }
}