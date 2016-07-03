//
//  DataList.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/27.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation

class DataList: NSObject {
    
    var objectId:String?
    var title:String?
    var location:CLLocationCoordinate2D?
    var type:String?
    
    var endTime:NSDate?
    var startTime:NSDate?
    var createDate:String?
    var updateDate:String?
    
    
    var placeId:String?
    var vicinity:String?
    
    func getIntervalTime() -> String
    {
        if endTime == nil || startTime == nil {
            return "?分"
        }
        let span = endTime!.timeIntervalSinceDate(startTime!)
        let daySpan = span/60
        
        return String(daySpan)+"分"
    }
}