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
    var enterButton:UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
//        
//        let myImageView = UIImageView(frame:frame)
//        myImageView.image = UIImage(named: "3")
//        self.addSubview(myImageView)
//        
//        self.backgroundColor = UIColor.blackColor()
        
        //buttonの設置
        enterButton = UIButton(frame: CGRectMake(5, 0, 220, 30))
        enterButton.layer.cornerRadius = 5.0
        enterButton.setTitle("詳細を確認する", forState: .Normal)
        enterButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        enterButton.backgroundColor = Color.green
        enterButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        enterButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
//        enterButton.addTarget(self, action: #selector(RequestWorkViewController.onClickButton(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(enterButton)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}