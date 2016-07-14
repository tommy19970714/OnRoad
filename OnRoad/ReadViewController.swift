//
//  ReadViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/15.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {
    
    var textView:UITextView!
    var readFile:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = UITextView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        textView.editable = false
//        textView.selectable = false
        textView.font = UIFont.systemFontOfSize(15)
        
        if let filePath = NSBundle.mainBundle().pathForResource(readFile, ofType: "txt") {
            do {
                let str = try String(contentsOfFile: filePath,
                                     encoding: NSUTF8StringEncoding)
                self.textView.text = str
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        self.view = textView
    }
}
