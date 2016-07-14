//
//  RequestFormViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class RequestFormViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var startLocation:CLLocationCoordinate2D!
    var endLocation:CLLocationCoordinate2D!
    
    var decideButton:UIBarButtonItem!
    
    var firstText:String? = "詳細:\n\n日時:\n\n運賃:\n\n連絡先:\n\n"
    var firstTitle:String?
    
    var objectId:String?
    
    var isLook:Bool?
    var iswork:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView
//        textView.delegate = self
        textView.text = firstText
        
        //textField
        textField.delegate = self
        textField.text = firstTitle
        
        textField.becomeFirstResponder()
        
        //navigationbar
        if isLook == false
        {
            decideButton = UIBarButtonItem(title: "決定", style: .Plain, target: self, action: #selector(RequestFormViewController.clickDecideButton(_:)))
            self.navigationItem.rightBarButtonItem = decideButton
        }
        else
        {
            textField.enabled = false
            textView.editable = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    func clickDecideButton(sender:UIButton)
    {
        if textField.text == nil || (textView.text == firstText)
        {
            AlertHelper.showAlert("アラート", message: "タイトル又は内容が入力されていません．", cancel: "ok", destructive: nil, others: nil, parent: self){
                (buttonIndex: Int) in
            }
            return
        }
        
        if iswork == true
        {
            let workDataModel = WorkDataModel()
            workDataModel.setParam(textField.text!,text: textView.text, startPoint: startLocation, endPoint: endLocation,objectId: objectId)
            workDataModel.save({ result -> Void in
                
                var message:String?
                if result == true {
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
        else
        {
            let commentDataModel = CommentDataModel()
            commentDataModel.setParam(textField.text!,text: textView.text, location: startLocation, objectId: objectId)
            commentDataModel.save({ result -> Void in
                
                var message:String?
                if result == true {
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
        
        
        if textField == self.textField {
            self.textView.becomeFirstResponder()
        }else if textField == textView {
            self.textView.resignFirstResponder()
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}