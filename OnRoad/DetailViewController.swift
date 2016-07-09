//
//  DetailViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/09.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class DetailViewController: UIViewController {
    
    var location:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panoView = GMSPanoramaView.panoramaWithFrame(CGRectZero,nearCoordinate:location)
        
        self.view = panoView;
    }
    
    static func present(from: UIViewController) {
        let vc = DetailViewController.instantiate()
        from.presentViewController(vc, animated: true, completion: nil)
    }
}
