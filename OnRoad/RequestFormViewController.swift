//
//  RequestFormViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class RequestFormViewController: UIViewController,UITextViewDelegate {
    
    var textView:UITextView!
    
    var startLocation:CLLocationCoordinate2D!
    var endLocation:CLLocationCoordinate2D!
    
    var decideButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView
        textView = UITextView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        textView.text = "要件:\n\n期間:\n\n金額:\n\n連絡先:\n\n"
        textView.font = UIFont.systemFontOfSize(CGFloat(20))
        textView.textColor = UIColor.blackColor()
        textView.textAlignment = NSTextAlignment.Left
        textView.dataDetectorTypes = UIDataDetectorTypes.All
        textView.delegate = self
        
        self.view.addSubview(textView)
        textView.becomeFirstResponder()
        
        //navigationbar
        decideButton = UIBarButtonItem(title: "決定", style: .Plain, target: self, action: #selector(RequestFormViewController.clickDecideButton(_:)))
        self.navigationItem.rightBarButtonItem = decideButton
    }
    
    func clickDecideButton(sender:UIButton)
    {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //テキストビューが変更された
    func textViewDidChange(textView: UITextView) {
        print("textViewDidChange : \(textView.text)");
    }
    
    // テキストビューにフォーカスが移った
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing : \(textView.text)");
        return true
    }
    
    // テキストビューからフォーカスが失われた
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        print("textViewShouldEndEditing : \(textView.text)");
        return true
    }
}