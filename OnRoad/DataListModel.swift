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
        if types.isEmpty
        {
            dataLists.removeAll()
            return
        }
        dataLists.removeAll()
        if (types.indexOf(Types.opendata.rawValue) != nil)
        {
            let getDataModel = GetDataModel(region: region)
            getDataModel.getOpenData({result in
                self.dataLists += result
            })
        }
        
        if (types.count != 1 || types[0] != Types.opendata.rawValue)
        {
            let placeApiModel = PlaceApiModel(region: region)
            placeApiModel.setTypeString(types)
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