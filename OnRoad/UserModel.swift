//
//  UserModel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/13.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation
import NCMB

class UserModel: NSObject {
    
    var userName:String?
    var mail:String?
//    var phoneNumber:String?
//    var carType:String?
    var password:String?
    
    
    func checkUserId(name:String,callback:Bool? -> Void)
    {
        let query = NCMBQuery(className: "User")
        query.whereKey("UserName", equalTo: name)
        
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if error != nil {
                print("error")
                callback(nil)
                
            }else{
                if objects.count == 0
                {
                    callback(false)
                }
                else
                {
                    callback(true)
                }
            }
        })
    }
    
    func checkUserId2(name:String,password:String,callback:Bool? -> Void)
    {
        let query = NCMBQuery(className: "User")
        query.whereKey("UserName", equalTo: name)
        
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if error != nil {
                print("error")
                callback(nil)
                
            }else{
                if objects.count == 1 && objects.first?.objectForKey("Password") as? String == password
                {
                    UserDefaults.userId = objects.first?.objectId
                    callback(true)
                }
                else
                {
                    callback(false)
                }
            }
        })
    }
    
    func registration(callback:Bool -> Void)
    {
        if (userName == nil) || (mail == nil) || (password == nil)
        {
            callback(false)
            return
        }
        let obj2 = NCMBObject(className: "User")
        
        // オブジェクトに値を設定
        obj2.setObject(userName, forKey: "UserName")
        obj2.setObject(mail, forKey: "Mail")
//        obj2.setObject(phoneNumber, forKey: "PhoneNumber")
//        obj2.setObject(carType, forKey: "CarType")
        obj2.setObject(password, forKey: "Password")
        
        if !CheckReachability("google.com") {
            callback(false)
        }
        
        // データストアへの保存を実施
        obj2.saveEventually { (error: NSError!) -> Void in
            if error != nil {
                // 保存に失敗した場合の処理
                print("error")
                callback(false)
            }else{
                // 保存に成功した場合の処理
                print("save success")
                
                
                self.checkUserId2(self.userName!,password: self.password!,callback: {result in
                    if result == true
                    {
                        UserDefaults.userName = self.userName
                        UserDefaults.mail = self.mail
//                        UserDefaults.phoneNumber = self.phoneNumber
//                        UserDefaults.carType = self.carType
                        callback(true)
                    }
                    else
                    {
                        callback(false)
                    }
                })
                
                
            }
        }
    }
}