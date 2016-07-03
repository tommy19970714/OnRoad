//
//  StreetViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/29.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class StreetViewController: UIViewController {
    
    var location:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panoView = GMSPanoramaView.panoramaWithFrame(CGRectZero,nearCoordinate:location)
        
        self.view = panoView;
    }
}
