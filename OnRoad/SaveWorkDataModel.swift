//
//  PostWorkDataModel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import NCMB
import MapKit

class SaveWorkDataModel: NSObject {
    
    internal var tytle:String?
    internal var text:String?
    internal var startPoint:NCMBGeoPoint?
    internal var endPoint:NCMBGeoPoint?
    
    init(tytle:String,text:String,startPoint:CLLocationCoordinate2D,endPoint:CLLocationCoordinate2D) {
        self.tytle = tytle
        self.text = text
        self.startPoint = NCMBGeoPoint(latitude: startPoint.latitude, longitude: startPoint.longitude)
        self.endPoint = NCMBGeoPoint(latitude: endPoint.latitude, longitude: endPoint.longitude)
    }
    
    func save(callback: (NSError?) -> Void)
    {
        //読み込み
        let userId = UserDefaults.userId
        let userName = UserDefaults.userName
        
        // クラスのNCMBObjectを作成
        let obj2 = NCMBObject(className: "WorkData")
        
        // オブジェクトに値を設定
        obj2.setObject(startPoint, forKey: "StartPoint")
        obj2.setObject(endPoint, forKey: "EndPoint")
        obj2.setObject(tytle, forKey: "Tytle")
        obj2.setObject(text, forKey: "Text")
        obj2.setObject(userId, forKey: "UserId")
        obj2.setObject(userName, forKey: "UserName")
        
        // データストアへの保存を実施
        obj2.saveEventually { (error: NSError!) -> Void in
            if error != nil {
                // 保存に失敗した場合の処理
                print("error")
                
            }else{
                // 保存に成功した場合の処理
                print("save success")
                
            }
            callback(error)
        }

    }
}