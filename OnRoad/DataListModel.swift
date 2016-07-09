//
//  AnnotationModel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/27.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit
import MapKit

class DataListModel: NSObject {
    
    
    private dynamic var dataLists:[DataList] = []
    
    class var sharedInstance: DataListModel {
        struct Singleton {
            static let instance:DataListModel = DataListModel()
        }
        return Singleton.instance
    }
    
    func getData() -> [DataList] {
        return self.dataLists
    }
    
    func update(region:MKCoordinateRegion,types:[String])
    {
        var tempTypes = types
        dataLists.removeAll()
        
        //空の場合
        if types.isEmpty
        {
            return
        }
        
        if let indexOpenData = tempTypes.indexOf(Types.opendata.rawValue)
        {
            tempTypes.removeAtIndex(indexOpenData)
            
            let getDataModel = GetDataModel(region: region)
            getDataModel.getOpenData({result in
                self.dataLists += result
            })
        }
        if let indexWorkData = tempTypes.indexOf(Types.workdata.rawValue)
        {
            tempTypes.removeAtIndex(indexWorkData)
            
            let getDataModel = GetDataModel(region: region)
            getDataModel.getWorkData({result in
                self.dataLists += result
            })
        }
        if let indexRestaurantData = tempTypes.indexOf(Types.restaurant.rawValue)
        {
            tempTypes.removeAtIndex(indexRestaurantData)
            
            let placeApiModel = PlaceApiModel(region: region)
            placeApiModel.setTypeString([Types.restaurant.rawValue])
            placeApiModel.getPlaceData({result in
                self.dataLists += result
                
            })
        }
        
        if !tempTypes.isEmpty
        {
            let placeApiModel = PlaceApiModel(region: region)
            placeApiModel.setTypeString(tempTypes)
            placeApiModel.getPlaceData({result in
                self.dataLists += result
                
            })
        }

        
    }
    
    func updateOpenData(region:MKCoordinateRegion){
        
        let getDataModel = GetDataModel(region: region)
        getDataModel.getOpenData({result in
            self.dataLists = result
        })
        
    }
    
    func updatePlaceAPI(region:MKCoordinateRegion,types:[String]){
        if types.isEmpty
        {
            return
        }
        let placeApiModel = PlaceApiModel(region: region)
        placeApiModel.setTypeString(types)
        placeApiModel.getPlaceData({result in
            self.dataLists = result
            
        })
        
    }
    
    
}