//
//  GetAnnotationModel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/27.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation
import NCMB
import MapKit

class GetDataModel: NSObject {
    
    var region:MKCoordinateRegion?
    var topRight:CLLocationCoordinate2D?
    var bottomLeft:CLLocationCoordinate2D?
    var swGeoPoint:NCMBGeoPoint?
    var neGeoPoint:NCMBGeoPoint?
    
    init(region:MKCoordinateRegion)
    {
//        topRight = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
//        bottomLeft = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        
        swGeoPoint = NCMBGeoPoint(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        neGeoPoint = NCMBGeoPoint(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
    }
    
    func getOpenData(callback: (([DataList])->()))
    {
        // クラスのNCMBObjectを作成
        let obj3 = NCMBQuery(className: "Opendata1")
        // objectIdプロパティを設定
        obj3.whereKey("Location", withinGeoBoxFromSouthwest: swGeoPoint!, toNortheast:neGeoPoint!)
        obj3.limit = 100
        // 設定されたobjectIdを元にデータストアからデータを取得
        obj3.findObjectsInBackgroundWithBlock({(objects, error) in
            if error != nil {
                // 取得に失敗した場合の処理
            }else{
                // 取得に成功した場合の処理
                
                var dataLists:[DataList] = []
                for data in objects{
                    var dataList = DataList()
                    let place = data.objectForKey("Location") as! NCMBGeoPoint
                    dataList.location = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                    
                    dataList.objectId = data.objectId
                    dataList.title = data.objectForKey("Title") as! String
                    dataList.startTime = data.objectForKey("StartTime") as! NSDate
                    dataList.endTime = data.objectForKey("EndTime") as! NSDate
                    dataList.updateDate = data.objectForKey("updateDate") as! String
                    dataList.createDate = data.objectForKey("createDate") as! String
                    dataList.carType = data.objectForKey("carType") as! String
                    dataList.type = Types.opendata.rawValue
                    
                    dataLists.append(dataList)
                }
                callback(dataLists)
            }
        })
    }
    
    func getWorkData(callback: (([DataList])->()))
    {
        // クラスのNCMBObjectを作成
        let obj3 = NCMBQuery(className: "WorkData")
        // objectIdプロパティを設定
        obj3.whereKey("StartPoint", withinGeoBoxFromSouthwest: swGeoPoint!, toNortheast:neGeoPoint!)
        obj3.limit = 100
        // 設定されたobjectIdを元にデータストアからデータを取得
        obj3.findObjectsInBackgroundWithBlock({(objects, error) in
            if error != nil {
                // 取得に失敗した場合の処理
            }else{
                // 取得に成功した場合の処理
                
                var dataLists:[DataList] = []
                for data in objects{
                    var dataList = DataList()
                    let place = data.objectForKey("Location") as! NCMBGeoPoint
                    dataList.location = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                    
                    dataList.objectId = data.objectId
                    dataList.title = data.objectForKey("Title") as! String
                    dataList.startTime = data.objectForKey("StartTime") as! NSDate
                    dataList.endTime = data.objectForKey("EndTime") as! NSDate
                    dataList.updateDate = data.objectForKey("updateDate") as! String
                    dataList.createDate = data.objectForKey("createDate") as! String
                    dataList.carType = data.objectForKey("carType") as! String
                    dataList.type = Types.opendata.rawValue
                    
                    dataLists.append(dataList)
                }
                callback(dataLists)
            }
        })
    }
}