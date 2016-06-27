//
//  ViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/26.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var isloaded:Bool = false
    
    var dataLists:[DataList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataListModel.sharedInstance.addObserver(self, forKeyPath: "dataLists", options: [.New], context: nil)
        self.dataLists = DataListModel.sharedInstance.getData()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        
        if (locationManager != NSNull()) {
            locationManager?.delegate = self
            
            locationManager?.requestAlwaysAuthorization()
            
            
            let status = CLLocationManager.authorizationStatus()
            switch status{
            case .Restricted, .Denied:
                break
            case .NotDetermined:
                // iOS8での位置情報追跡リクエストの方法
                if ((locationManager?.respondsToSelector("requestWhenInUseAuthorization")) != nil){
                    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                    locationManager?.requestWhenInUseAuthorization()
                    locationManager?.startUpdatingLocation()
                }else{
                    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                    locationManager?.startUpdatingLocation()
                }
            case .AuthorizedWhenInUse, .AuthorizedAlways:
                // 従来の位置情報追跡リクエストの方法
                locationManager?.startUpdatingLocation()
            default:
                break
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        DataListModel.sharedInstance.removeObserver(self, forKeyPath: "dataLists")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //監視追加
        DataListModel.sharedInstance.addObserver(self, forKeyPath: "dataLists", options: [.New], context: nil)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        let latitude = newLocation.coordinate.latitude
        let longitude = newLocation.coordinate.longitude
        let location = CLLocationCoordinate2DMake(latitude,longitude)
        
        var region: MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        mapView.setRegion(region, animated: false)

        //地図の形式
        locationManager?.stopUpdatingLocation()
        isloaded = true
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !isloaded
        {
            return
        }
        DataListModel.sharedInstance.update(mapView.region)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "dataLists"{
            //ゲッタを使って変更を取得
            self.dataLists = DataListModel.sharedInstance.getData()
            mapView.removeAnnotations(mapView.annotations)
            for data in dataLists{
                let annotation = MKPointAnnotation()
                annotation.coordinate = data.location!
                annotation.title = data.title
                annotation.subtitle = data.getIntervalTime()
                print(data.title)
                
                mapView.addAnnotation(annotation)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

