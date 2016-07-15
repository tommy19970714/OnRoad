//
//  PostWorkDataModel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import NCMB
import MapKit

class WorkDataModel: NSObject {
    
    internal var title:String?
    internal var text:String?
    internal var startPoint:NCMBGeoPoint?
    internal var endPoint:NCMBGeoPoint?
    internal var objectId:String?
    
    func setParam(title:String,text:String,startPoint:CLLocationCoordinate2D,endPoint:CLLocationCoordinate2D,objectId:String?) {
        self.title = title
        self.text = text
        self.startPoint = NCMBGeoPoint(latitude: startPoint.latitude, longitude: startPoint.longitude)
        self.endPoint = NCMBGeoPoint(latitude: endPoint.latitude, longitude: endPoint.longitude)
        self.objectId = objectId
    }
    
    func save(callback: (Bool) -> Void)
    {
        //読み込み
        let userId = UserDefaults.userId
        let userName = UserDefaults.userName
        
        // クラスのNCMBObjectを作成
        let obj2 = NCMBObject(className: "WorkData")
        
        // オブジェクトに値を設定
        obj2.setObject(startPoint, forKey: "StartPoint")
        obj2.setObject(endPoint, forKey: "EndPoint")
        obj2.setObject(title, forKey: "Title")
        obj2.setObject(text, forKey: "Text")
        obj2.setObject(userId, forKey: "UserId")
        obj2.setObject(userName, forKey: "UserName")
        
        if self.objectId != nil {
            obj2.objectId = objectId
        }
        
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
                callback(true)
            }
        }
    }
    func search(callback: (([DataList])->()))
    {
        //読み込み
        let userId = UserDefaults.userId
//        let userName = UserDefaults.userName
        
        let query = NCMBQuery(className: "WorkData")
        query.whereKey("UserId", equalTo: userId)
        
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if error != nil {
                print("error")
                
            }else{
                
                var dataLists:[DataList] = []
                for data in objects{
                    let dataList = DataList()
                    let place = data.objectForKey("StartPoint") as! NCMBGeoPoint
                    dataList.location = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                    
                    let endPoint = data.objectForKey("EndPoint") as! NCMBGeoPoint
                    dataList.endPoint = CLLocationCoordinate2D(latitude: endPoint.latitude, longitude: endPoint.longitude)
                    
                    dataList.objectId = data.objectId
                    dataList.title = data.objectForKey("Title") as? String
                    dataList.text = data.objectForKey("Text") as? String
                    dataList.userId = data.objectForKey("UserId") as? String
                    dataList.userName = data.objectForKey("UserName") as? String
                    
                    dataList.updateDate = data.objectForKey("updateDate") as? String
                    dataList.createDate = data.objectForKey("createDate") as? String
                    dataList.type = Types.workdata.rawValue
                    
                    dataLists.append(dataList)
                }
                callback(dataLists)

            }
            
        })
    }
    
    func deleteObject(object:DataList,callback: (Bool) -> Void)
    {
        // testクラスへのNCMBObjectを設定
        let obj6 = NCMBObject(className: "WorkData")
        // objectIdプロパティを設定
        obj6.objectId = object.objectId
        
        if !CheckReachability("google.com") {
            callback(false)
        }
        
        // 設定されたobjectIdを元にデータストアからデータを取得
        obj6.fetchInBackgroundWithBlock({ (error: NSError!) -> Void in
            if error != nil {
                // 取得に失敗した場合の処理
            }else{
                // 取得に成功した場合の処理
                // フィールドの値をインクリメントする
                obj6.deleteInBackgroundWithBlock({ (error: NSError!) -> Void in
                    if error != nil {
                        // 削除に失敗した場合の処理
                        callback(false)
                    }else{
                        // 削除に成功した場合の処理
                        callback(true)
                    }
                })
            }
        })
    }
}