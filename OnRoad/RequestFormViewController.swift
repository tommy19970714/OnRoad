//
//  RequestFormViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class RequestFormViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate {
    
    var textView:UITextView!
    var textField:UITextField!
    
    var startLocation:CLLocationCoordinate2D!
    var endLocation:CLLocationCoordinate2D!
    
    var decideButton:UIBarButtonItem!
    
    let firstText = "要件:\n\n期間:\n\n金額:\n\n連絡先:\n\n"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView
        textView = UITextView(frame: CGRectMake(0, 60, view.frame.width, view.frame.height-60))
        textView.text = firstText
        textView.font = UIFont.systemFontOfSize(CGFloat(20))
        textView.textColor = UIColor.blackColor()
        textView.textAlignment = NSTextAlignment.Left
        textView.dataDetectorTypes = UIDataDetectorTypes.All
        textView.delegate = self
        self.view.addSubview(textView)
        
        //textField
        textField = UITextField(frame: CGRectMake(0, 0, view.frame.width-15, 45))
        textField.placeholder = "タイトル"
        textField.font = UIFont.systemFontOfSize(CGFloat(20))
        textField.textColor = UIColor.blackColor()
        textField.textAlignment = NSTextAlignment.Left
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.layer.position = CGPoint(x:self.view.bounds.width/2,y:-27)
        self.textView.addSubview(textField)
        
        textField.becomeFirstResponder()
        
        //navigationbar
        decideButton = UIBarButtonItem(title: "決定", style: .Plain, target: self, action: #selector(RequestFormViewController.clickDecideButton(_:)))
        self.navigationItem.rightBarButtonItem = decideButton
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func clickDecideButton(sender:UIButton)
    {
        if textField.text == nil || textView.text == firstText
        {
            AlertHelper.showAlert("アラート", message: "タイトル又は内容が入力されていません．", cancel: "ok", destructive: nil, others: nil, parent: self){
                (buttonIndex: Int) in
            }
            return
        }
        let saveWorkDataModel = SaveWorkDataModel(tytle: textField.text!,text: textView.text, startPoint: startLocation, endPoint: endLocation)
        saveWorkDataModel.save({(error: NSError?) -> Void in
            
            var message:String?
            if error == nil {
                message = "送信されました！"
            }else {
                message = "送信できませんでした."
            }
            AlertHelper.showAlert("アラート", message: message!, cancel: "ok", destructive: nil, others: nil, parent: self) {
                (buttonIndex: Int) in
                // 押されたボタンのインデックスにて処理を振り分ける
                switch buttonIndex {
                default :
                    // キャンセル
                    print("\(buttonIndex)")
                    break
                }
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        })
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
    
    /*
     UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
     */
    func textFieldDidBeginEditing(textField: UITextField){
        print("textFieldDidBeginEditing:" + textField.text!)
    }
    
    /*
     UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
     */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing:" + textField.text!)
        
        return true
    }
    
    /*
     改行ボタンが押された際に呼ばれるデリゲートメソッド.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}