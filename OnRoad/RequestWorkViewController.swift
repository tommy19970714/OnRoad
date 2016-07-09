//
//  RequestWorkViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RequestWorkViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var mapView: MKMapView!
    var searchBar: UISearchBar!
    var backbutton: UIBarButtonItem!
    
    var enterButton:UIButton!
    var centerPin:UIImageView!
    
    var message:String?
    var location:CLLocationCoordinate2D?
    var annotation:MKPointAnnotation?
    var line = MKPolyline()
    
    var locationManager: CLLocationManager!
    
    var isFirst:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MapViewの生成.
        mapView = MKMapView()
        mapView.frame = self.view.bounds
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
        
        //location manager
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
        
        //navigation bar
        if isFirst
        {
            backbutton = UIBarButtonItem(image: UIImage(named: "closemenu"), style: .Plain, target: self, action: #selector(RequestWorkViewController.backHome(_:)))
            self.navigationItem.leftBarButtonItem = backbutton
        }
        self.setupSearchBar()
        
        //Pinの設置
        let pinImage = UIImage(named: "センターピン")
        centerPin = UIImageView(frame: CGRectMake(view.frame.width/2-30, view.frame.height/2-30, 60, 60))
        centerPin.image = pinImage
        self.mapView.addSubview(centerPin)
        
        //buttonの設置
        enterButton = UIButton(frame: CGRectMake(view.frame.width/2-100, view.frame.height-100, 200, 50))
        enterButton.layer.cornerRadius = 5.0
        enterButton.setTitle(message, forState: .Normal)
        enterButton.backgroundColor = Color.green
        enterButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        enterButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        enterButton.addTarget(self, action: #selector(RequestWorkViewController.onClickButton(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(enterButton)
        
        //pinを置く
        if location != nil
        {
            annotation = MKPointAnnotation()
            annotation!.coordinate = location!
//            myPin.title = "タイトル"
//            myPin.subtitle = "サブタイトル"
            mapView.addAnnotation(annotation!)
        }

        
    }
    
    func onClickButton(sender:UIButton)
    {
        if isFirst
        {
            let requestWorkViewController = RequestWorkViewController()
            requestWorkViewController.location = mapView.centerCoordinate
            requestWorkViewController.isFirst = false
            requestWorkViewController.message = "ここで荷物を下ろす"
            self.navigationController!.pushViewController(requestWorkViewController, animated: true)
        }
        else
        {
            let requestFromViewController = RequestFormViewController()
            requestFromViewController.startLocation = location
            requestFromViewController.endLocation = mapView.centerCoordinate
            self.navigationController!.pushViewController(requestFromViewController, animated: true)
        }
    }
    
    func backHome(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if isFirst == false
        {
            mapView.removeOverlay(line)
            
            var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
            points.append(mapView.centerCoordinate)
            points.append(annotation!.coordinate)
            line = MKPolyline(coordinates: &points, count: points.count)
            mapView.addOverlay(line)
        }
    }
    
    //描画メソッド実行時の呼び出しメソッド
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let testRender = MKPolylineRenderer(overlay: overlay)
        
        //直線の幅を設定する。
        testRender.lineWidth = 3
        
        //直線の色を設定する。
        testRender.strokeColor = UIColor.redColor()
        
        return testRender
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
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
    // MARK: - private methods
    private func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "検索"
            searchBar.showsCancelButton = false
            searchBar.autocapitalizationType = UITextAutocapitalizationType.None
            searchBar.keyboardType = UIKeyboardType.Default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    //テキストが変更される毎に呼ばれる
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        self.navigationItem.leftBarButtonItem = nil
        
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = false
        self.navigationItem.leftBarButtonItem = backbutton
        self.searchBar.resignFirstResponder()
        
        return true
    }
    
    // Cancelボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
    }
    
    // Searchボタンが押された時に呼ばれる
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }

}