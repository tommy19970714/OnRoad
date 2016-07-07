//
//  Types.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/03.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation

enum Types :String {
    
    case convenience_store = "convenience_store"
//    case cafe = "cafe"
//    case car_dealer = "car_dealer"
//    case car_rental = "car_rental"
//    case car_repair = "car_repair"
//    case car_wash = "car_wash"
    case gas_station = "gas_station"
    case food = "food"
//    case hospital = "hospital"
//    case restaurant = "restaurant"
    case parking = "parking"
    case opendata = "opendata"
    
    static let allType: [String] = [opendata.rawValue,food.rawValue,convenience_store.rawValue, gas_station.rawValue, parking.rawValue, opendata.rawValue]
}