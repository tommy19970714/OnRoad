//
//  SignupViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/13.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class SignupViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var carField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var backbutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        mailField.delegate = self
        phoneField.delegate = self
        carField.delegate = self
        passwordField.delegate = self
        
        backbutton = UIBarButtonItem(image: UIImage(named: "closemenu"), style: .Plain, target: self, action: #selector(SignupViewController.backHome(_:)))
        self.navigationItem.leftBarButtonItem = backbutton
        
    }
    override func viewWillAppear(animated: Bool) {
        self.usernameField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSignup(sender: UIButton) {
        if checkField()
        {
            signup()
        }
    }
    
    func backHome(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //    TextFieldのリターンを押した処理
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == usernameField {
            mailField.becomeFirstResponder()
        }else if textField == mailField {
            phoneField.becomeFirstResponder()
        }else if textField == phoneField {
            carField.becomeFirstResponder()
        }else if textField == passwordField {
            if checkField()
            {
                signup()
            }
        }
        
        return true
    }
    
    func checkField() -> Bool
    {
        if self.usernameField.text?.utf16.count >= 3 && self.usernameField.text?.utf16.count <= 15 && checkStr(usernameField.text){
            
            if (mailField.text?.containsString("@") == true) && (mailField.text?.utf16.count >= 3) {
                
                if (checkNum(phoneField.text) == true) && self.phoneField.text?.utf16.count >= 9 {
                    
                    if carField.text != nil {
                        
                        if passwordField.text?.utf16.count >= 4 && passwordField.text?.utf16.count <= 16 && checkStr(passwordField.text){
                            
                            return true
                        }else{
                            AlertHelper.showOkAlert("エラー", message: "パスワードは半角英数字で4文字以上、16文字以下にしてください．", parent: self)
                            return false
                        }
                    }else{
                        AlertHelper.showOkAlert("エラー", message: "車の種類が選択されていません．", parent: self)
                        return false
                    }
                }else{
                    AlertHelper.showOkAlert("エラー", message: "電話番号が間違っています．", parent: self)
                    return false
                }
            }else {
                AlertHelper.showOkAlert("エラー", message: "メールアドレスが間違っています．", parent: self)
                return false
            }
        }else{
            AlertHelper.showOkAlert("エラー", message: "ユーザー名は半角英数字で3から15文字以内です．", parent: self)
            return false
        }
    }
    
    func checkStr(str:String?) -> Bool
    {
        if str == nil{
            return false
        }
        
        var result:Bool = true
        let characters = str!.characters.map { String($0) }
        
        for c in characters
        {
            if Int(c) == nil && c.uppercaseString == c.lowercaseString
            {
                result = false
            }
        }
        
        return result
    }
    
    func checkNum(str:String?) ->Bool
    {
        if str == nil {
            return false
        }
        if(Int(str!) == nil){
            return false
        }
        return true
    }
    
    func signup(){
        let userName = self.usernameField.text
        let userModel = UserModel()
        userModel.userName = userName
        userModel.mail = self.mailField.text
        userModel.phoneNumber = self.phoneField.text
        userModel.carType = self.carField.text
        userModel.password = self.passwordField.text
        
        userModel.checkUserId(userName!,callback: {responce in
            
            if (responce == false)
            {
                userModel.registration({result in
                    
                    if result == true
                    {
                        AlertHelper.showAlert("登録", message: "登録が完了しました！", cancel: "ok", destructive: nil, others: nil, parent: self){
                            (buttonIndex: Int) in
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            let notification : NSNotification = NSNotification(name: "Login", object: self, userInfo: nil)
                            NSNotificationCenter.defaultCenter().postNotification(notification)
                        }
                    }
                    else
                    {
                        AlertHelper.showOkAlert("エラー", message: "登録できませんでした．", parent: self)
                    }
                    
                })
            }
            else if (responce == nil)
            {
                AlertHelper.showOkAlert("エラー", message: "インターネットに接続されていない可能性があります．", parent: self)
            }
            else
            {
                AlertHelper.showOkAlert("エラー", message: "このユーザー名は既に使われています．．", parent: self)
            }
        })
    }
}

