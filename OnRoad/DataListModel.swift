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
    
    func update(region:MKCoordinateRegion){
        
        print("updare")
        
        let getDataModel = GetDataModel(region: region)
        getDataModel.getOpenData({result in
            self.dataLists = result
            
        })
        
    }
    
    
}