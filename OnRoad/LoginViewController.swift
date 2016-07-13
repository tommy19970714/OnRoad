//
//  LoginViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/13.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var backbutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        backbutton = UIBarButtonItem(image: UIImage(named: "closemenu"), style: .Plain, target: self, action: #selector(LoginViewController.backHome(_:)))
        self.navigationItem.leftBarButtonItem = backbutton
        
    }
    override func viewWillAppear(animated: Bool) {
        self.usernameField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickLogin(sender: UIButton) {
        
    }
    func backHome(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //    TextFieldのリターンを押した処理
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            if checkField()
            {
                login()
            }
        }
        
        return true
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
    
    func checkField() -> Bool
    {
        if self.usernameField.text?.utf16.count >= 3 && self.usernameField.text?.utf16.count <= 15 && checkStr(usernameField.text){
            
            if passwordField.text?.utf16.count >= 4 && passwordField.text?.utf16.count <= 16 && checkStr(passwordField.text){
                
                return true
            }else{
                AlertHelper.showOkAlert("エラー", message: "パスワードは半角英数字で4文字以上、16文字以下にしてください．", parent: self)
                return false
            }
        }else{
            AlertHelper.showOkAlert("エラー", message: "ユーザー名は半角英数字で3から15文字以内です．", parent: self)
            return false
        }
    }
    
    func login()
    {
        let userModel = UserModel()
        userModel.checkUserId2(usernameField.text!, password: passwordField.text!, callback: {result in
            if result == true
            {
                AlertHelper.showAlert("ログイン", message: "ログインが成功しました！", cancel: "ok", destructive: nil, others: nil, parent: self){
                    (buttonIndex: Int) in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    let notification : NSNotification = NSNotification(name: "Login", object: self, userInfo: nil)
                    NSNotificationCenter.defaultCenter().postNotification(notification)
                }
            }
            else if result == false
            {
                AlertHelper.showOkAlert("エラー", message: "ユーザー名またはパスワードが間違っています．", parent: self)
            }
            else
            {
                AlertHelper.showOkAlert("エラー", message: "インターネットに接続されていない可能性があります．", parent: self)
            }
        })
    }
}