//
//  GetDetailPlaceModel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/10.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit
import Alamofire
import SwiftDate

class GetDetailPlaceModel : NSObject {
    
    var requestURL = "https://maps.googleapis.com/maps/api/place/details/json"
    let accessKey = "AIzaSyAHO_ggw_eXr08BLFFSoxnvCKVF_Bz41IQ"
    var placeid:String?
    
    let requestPhotoURL = "https://maps.googleapis.com/maps/api/place/photo"
    
    func getDetail(callback: ((openTime:String?)->()))
    {
        Alamofire.request(.GET, requestURL, parameters: ["key" : accessKey,"placeid" : placeid!,"language":"ja"])
            .responseJSON {response in
                if response.result.isSuccess {
                    let json: JSON = JSON(response.result.value!)
                    
                    print(json)
                    let weekday = self.nowWeekday()
                    let opentime = json["result"]["opening_hours"]["weekday_text"][weekday].string
                    
                    callback(openTime: opentime)
                }
        }
        
    }
    
    func getImage(photoreference:String) -> String
    {
        let url = requestPhotoURL+"?key="+accessKey+"&maxwidth=400&photoreference="+photoreference
        
        return url
    }
    
    func nowWeekday() -> Int {
        
        let date = NSDate()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let unitFlags: NSCalendarUnit = [ .Year,
                                          .Month,
                                          .Day,
                                          .Weekday,
                                          .Hour,
                                          .Minute,
                                          .Second ]
        var components = calendar.components(unitFlags, fromDate:date)
        var weekDay = components.weekday

        
        return (components.weekday-1+6) % 7
    }
}