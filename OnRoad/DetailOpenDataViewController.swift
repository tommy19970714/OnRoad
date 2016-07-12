//
//  DetailOpenDataViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/12.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class DetailOpenDataViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    
    @IBOutlet weak var streetButton: UIButton!
    
    var dataList:DataList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = dataList?.title
        timeLabel.text = dataList?.getIntervalTime()
        carTypeLabel.text = dataList?.carType
        
        streetButton.addTarget(self, action: #selector(DetailOpenDataViewController.clickStreetView(_:)), forControlEvents: .TouchUpInside)
        
        giocoting()
    }
    
    func clickStreetView(sender:UIButton)
    {
        let streetViewController = StreetViewController()
        streetViewController.location = dataList?.location
        self.navigationController!.pushViewController(streetViewController, animated: true)
    }
    
    func giocoting() {
        // geocoderを作成.
        let myGeocorder = CLGeocoder()
        
        // locationを作成.
        let myLocation = CLLocation(latitude: (dataList?.location?.latitude)!, longitude: (dataList?.location?.longitude)!)
        
        // 逆ジオコーディング開始.
        myGeocorder.reverseGeocodeLocation(myLocation,
                                           completionHandler: { (placemarks, error) -> Void in
                                            
                                            var placemark: CLPlacemark!
                                            
                                            for placemark in placemarks! {
                                                
                                                self.addressLabel.text = (placemark.administrativeArea)! +  (placemark.locality)! +  (placemark.name)!
                                            }
        })
    }
}