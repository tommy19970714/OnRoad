//
//  CustomCalloutView.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/28.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    
    var image:UIImage?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let myImageView = UIImageView(frame:frame)
        myImageView.image = UIImage(named: "3")
        self.addSubview(myImageView)
        
        self.backgroundColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}