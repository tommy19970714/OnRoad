//
//  CommentDataModel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/15.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import NCMB
import MapKit

class CommentDataModel: NSObject {
    
    internal var title:String?
    internal var text:String?
    internal var location:NCMBGeoPoint?
    internal var objectId:String?
    
    func setParam(title:String,text:String,location:CLLocationCoordinate2D,objectId:String?) {
        self.title = title
        self.text = text
        self.location = NCMBGeoPoint(latitude: location.latitude, longitude: location.longitude)
        self.objectId = objectId
    }
    
    func save(callback: (Bool) -> Void)
    {
        //読み込み
        let userId = UserDefaults.userId
        let userName = UserDefaults.userName
        
        // クラスのNCMBObjectを作成
        let obj2 = NCMBObject(className: "CommentData")
        
        // オブジェクトに値を設定
        obj2.setObject(location, forKey: "Location")
        obj2.setObject(title, forKey: "Title")
        obj2.setObject(text, forKey: "Text")
        obj2.setObject(userId, forKey: "UserId")
        obj2.setObject(userName, forKey: "UserName")
        
        if self.objectId != nil {
            obj2.objectId = objectId
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
        
        let query = NCMBQuery(className: "CommentData")
        query.whereKey("UserId", equalTo: userId)
        
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if error != nil {
                print("error")
                
            }else{
                print(objects)
                
                var dataLists:[DataList] = []
                for data in objects{
                    let dataList = DataList()
                    let place = data.objectForKey("Location") as! NCMBGeoPoint
                    dataList.location = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                    
                    dataList.objectId = data.objectId
                    dataList.title = data.objectForKey("Title") as? String
                    dataList.text = data.objectForKey("Text") as? String
                    dataList.userId = data.objectForKey("UserId") as? String
                    dataList.userName = data.objectForKey("UserName") as? String
                    
                    dataList.updateDate = data.objectForKey("updateDate") as? String
                    dataList.createDate = data.objectForKey("createDate") as? String
                    dataList.type = Types.comment.rawValue
                    
                    dataLists.append(dataList)
                }
                callback(dataLists)
                
            }
            
        })
    }
    
    func deleteObject(object:DataList)
    {
        // testクラスへのNCMBObjectを設定
        let obj6 = NCMBObject(className: "CommentData")
        // objectIdプロパティを設定
        obj6.objectId = object.objectId
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
                    }else{
                        // 削除に成功した場合の処理
                    }
                })
            }
        })
    }
}