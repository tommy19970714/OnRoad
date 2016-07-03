//
//  PlaceApiMdel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/30.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

class PlaceApiModel: NSObject {
    
    var distance:CLLocationDistance!
    var requestURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    let accessKey = "AIzaSyAHO_ggw_eXr08BLFFSoxnvCKVF_Bz41IQ"
    
    var type:String?
    var location:CLLocationCoordinate2D?
    
    var next_page_token:String?
    var count:Int = 0
    
    init(region:MKCoordinateRegion)
    {
        let swGeoPoint = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        let neGeoPoint = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        
        let point1 = MKMapPointForCoordinate(swGeoPoint)
        let point2 = MKMapPointForCoordinate(neGeoPoint)
        
        
        distance = MKMetersBetweenMapPoints(point1,point2)/3
        location = region.center
        
    }
    
    func getPlaceData(callback: ([DataList]->()))
    {
        let locationStr:String = stringLoaction(location!)
        print(distance)
        print(locationStr)
        Alamofire.request(.GET, requestURL, parameters: ["key" : accessKey,"location": locationStr,"radius":distance, "types": type!])
            .responseJSON {responce in
                if responce.result.isSuccess {
//                    print(json.request)
                    let json: JSON = JSON(responce.result.value!)
                    var datalists:[DataList] = []
                    
                    print(json)
                    for i in 0...json["results"].count
                    {
                        let dataList = DataList()
                        dataList.objectId = json["results"][i]["id"].string
                        dataList.placeId = json["results"][i]["place_id"].string
                        dataList.title = json["results"][i]["name"].string
                        var coordinate = CLLocationCoordinate2D()
                        coordinate.latitude = json["results"][i]["geometry"]["location"]["lat"].doubleValue
                        coordinate.longitude = json["results"][i]["geometry"]["location"]["lng"].doubleValue
                        dataList.location = coordinate
                        dataList.vicinity = json["results"][i]["vicinity"].string
                        dataList.type = self.type
                        
                        datalists.append(dataList)
                    }
//                    if json["next_page_token"].string == nil
//                    {
//                        callback(datalists)
//                    }
//                    else
//                    {
//                        self.next_page_token = json["next_page_token"].string
//                        self.getNextData({result in
//                            
//                            if !result.isEmpty
//                            {
//                                for r in result
//                                {
//                                    datalists.append(r)
//                                }
//                            }
//                            callback(datalists)
//                        })
//                    }
                    
                    callback(datalists)
                }
        }
    }
    
    func getNextData(callback: ([DataList]->()))
    {
        count += 1
        if count > 4
        {
            return
        }
        Alamofire.request(.GET, requestURL, parameters: ["key" : accessKey,"next_page_token": next_page_token!])
            .responseJSON {responce in
                if responce.result.isSuccess {
                    
                    let json: JSON = JSON(responce.result.value!)
                    var datalists:[DataList] = []
                    
                    print(json)
                    for i in 0...json["results"].count
                    {
                        let dataList = DataList()
                        dataList.objectId = json["results"][i]["id"].string
                        dataList.placeId = json["results"][i]["place_id"].string
                        dataList.title = json["results"][i]["name"].string
                        var coordinate = CLLocationCoordinate2D()
                        coordinate.latitude = json["results"][i]["geometry"]["location"]["lat"].doubleValue
                        coordinate.longitude = json["results"][i]["geometry"]["location"]["lng"].doubleValue
                        dataList.location = coordinate
                        dataList.vicinity = json["results"][i]["vicinity"].string
                        dataList.type = self.type
                        
                        datalists.append(dataList)
                    }
                    
                    if json["next_page_token"].string == nil
                    {
                        callback(datalists)
                    }
                    else
                    {
                        self.next_page_token = json["next_page_token"].string
                        self.getNextData({result in
                            
                            if !result.isEmpty
                            {
                                for r in result
                                {
                                    datalists.append(r)
                                }
                            }
                            callback(datalists)
                        })
                    }
                }
        }
    }
    
    func stringLoaction(coordinate:CLLocationCoordinate2D) -> String
    {
        let lon = round(coordinate.longitude*pow(10,10))/pow(10,10)
        let lat = round(coordinate.latitude*pow(10,10))/pow(10,10)
        let dot:String = ","
        return String(lat) + dot + String(lon)
    }
}


