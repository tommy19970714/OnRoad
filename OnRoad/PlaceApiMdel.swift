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
    let accessKey = "AIzaSyBN-yL1gfZoradWA0q12jZc5ONRnA3_T4o"
    
    var type:String?
    var types:[String] = []
    var location:CLLocationCoordinate2D?
    
    var next_page_token:String?
    var count:Int = 0
    
    let chengeParamDistance:CLLocationDistance = 200.0
    
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
        //1500m以内なら，rankby=distanceに変更する 変更後をchengeParam = false
        var customParam = "radius"
        var customValue = String(distance)
        if distance < chengeParamDistance
        {
            customParam = "rankby"
            customValue = "distance"
        }
        
        Alamofire.request(.GET, requestURL, parameters: ["key" : accessKey,"location": locationStr,customParam:customValue, "types": type!])
            .responseJSON {responce in
                if responce.result.isSuccess {
                    let json: JSON = JSON(responce.result.value!)
                    var datalists:[DataList] = []
                    
                    if json["results"].count == 0
                    {
                        return
                    }
                    for i in 0...json["results"].count-1
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
                        dataList.photoReference = json["results"][i]["photos"][0]["photo_reference"].string
                        
                        var dataTypes:[String] = []
                        for j in 0...json["results"][i]["types"].count-1
                        {
                            let myType = json["results"][i]["types"][j].string
                            dataTypes.append(myType!)
                            for k in 0...self.types.count-1
                            {
                                if self.types[k] == myType
                                {
                                    dataList.type = myType!
                                }
                            }
                        }
                        dataList.types = dataTypes
                        
                        datalists.append(dataList)
                    }
                    
                    callback(datalists)
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
    
    func setTypeString(types:[String])
    {
        self.types = types
        if types.isEmpty
        {
            return
        }
        else if types.count == 1
        {
            self.type = types[0]
            return
        }
        
        var result:String = ""
        for t in types
        {
            result += t + "|"
        }
        self.type = result.chopSuffix(1)
    }
}


