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
    
}