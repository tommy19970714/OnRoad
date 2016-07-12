//
//  DetailWorkViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/12.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class DetailWorkViewController: UIViewController{
    
    var textView:UITextView!
    var textField:UITextField!
    
    var startLocation:CLLocationCoordinate2D!
    var endLocation:CLLocationCoordinate2D!
    
    
    var firstText:String? = "要件:\n\n期間:\n\n金額:\n\n連絡先:\n\n"
    var firstTitle:String? = "タイトル"
    
    var objectId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView
        textView = UITextView(frame: CGRectMake(0, 60, view.frame.width, view.frame.height-60))
        textView.text = firstText
        textView.font = UIFont.systemFontOfSize(CGFloat(20))
        textView.textColor = UIColor.blackColor()
        textView.textAlignment = NSTextAlignment.Left
        textView.dataDetectorTypes = UIDataDetectorTypes.All
        textView.editable = false
        self.view.addSubview(textView)
        
        //textField
        textField = UITextField(frame: CGRectMake(0, 0, view.frame.width-15, 45))
        textField.text = firstTitle
        textField.placeholder = "タイトル"
        textField.font = UIFont.systemFontOfSize(CGFloat(20))
        textField.textColor = UIColor.blackColor()
        textField.textAlignment = NSTextAlignment.Left
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.layer.position = CGPoint(x:self.view.bounds.width/2,y:-27)
        textField.enabled = false
        self.textView.addSubview(textField)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}