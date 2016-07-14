//
//  DataList.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/27.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation

class DataList: NSObject {
    
    //共通
    var objectId:String?
    var title:String?
    var location:CLLocationCoordinate2D?//workdataではstartPoint
    var type:String?
    
    //opendata
    var endTime:NSDate?
    var startTime:NSDate?
    var createDate:String?
    var updateDate:String?
    var carType:String?
    
    //google place
    var placeId:String?
    var vicinity:String?
    var types:[String]?
    var photoReference:String?
    
    //workData
    var endPoint:CLLocationCoordinate2D?
    var text:String?
    var userId:String?
    var userName:String?
    
    
    func getIntervalTime() -> String
    {
        if endTime == nil || startTime == nil {
            return "?分"
        }
        let span = endTime!.timeIntervalSinceDate(startTime!)
        let daySpan = round(span/60)
        
        return String(daySpan)+"分"
    }
}