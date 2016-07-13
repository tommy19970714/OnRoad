//
//  UserDefaults.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation

struct UserDefaults {
    private static let ud = NSUserDefaults.standardUserDefaults()
    
    private static let userIdKey = "userId"
    private static let userNameKey = "userName"
    private static let mailKey = "mail"
    private static let phoneNumberKey = "phoneNumber"
    private static let carTypeKey = "carType"
    
    static var userId: String? {
        get {
            return self.ud.stringForKey(userIdKey)
        }
        set {
            self.ud.setObject(newValue, forKey: userIdKey)
            self.ud.synchronize()
        }
    }

    static var userName: String? {
        get {
            return self.ud.stringForKey(userNameKey)
        }
        set {
            self.ud.setObject(newValue, forKey: userNameKey)
            self.ud.synchronize()
        }
    }
    static var mail: String? {
        get {
            return self.ud.stringForKey(mailKey)
        }
        set {
            self.ud.setObject(newValue, forKey: mailKey)
            self.ud.synchronize()
        }
    }
    static var phoneNumber: String? {
        get {
            return self.ud.stringForKey(phoneNumberKey)
        }
        set {
            self.ud.setObject(newValue, forKey: phoneNumberKey)
            self.ud.synchronize()
        }
    }
    static var carType: String? {
        get {
            return self.ud.stringForKey(carTypeKey)
        }
        set {
            self.ud.setObject(newValue, forKey: carTypeKey)
            self.ud.synchronize()
        }
    }
    
}