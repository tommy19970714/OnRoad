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

class RequestWorkViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource {
    
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
    var isWork:Bool = true
    
    var searchTableView:UITableView!
    var searchItem:[MKMapItem] = []
    
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
        enterButton = UIButton(frame: CGRectMake(0, view.frame.height-70, view.frame.width, 70))
        enterButton.layer.cornerRadius = 5.0
        enterButton.setTitle(message, forState: .Normal)
        enterButton.backgroundColor = Color.green
        enterButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        enterButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
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
        
        //tableviewの生成
        let h = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.height
        searchTableView = UITableView(frame: CGRect(x: 0, y: h, width: view.frame.width, height: view.frame.height-h))
        searchTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.hidden = true
        self.view.addSubview(searchTableView)
    }
    
    func onClickButton(sender:UIButton)
    {
        if isWork == false //口コミ
        {
            let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
            let requestFromViewController = stroBoardMain.instantiateViewControllerWithIdentifier("RequestFormViewController") as! RequestFormViewController
            requestFromViewController.startLocation = mapView.centerCoordinate
            requestFromViewController.iswork = false
            requestFromViewController.isLook = false
            requestFromViewController.firstText = "口コミ"
            self.navigationController!.pushViewController(requestFromViewController, animated: true)
        }
        else if isFirst
        {
            let requestWorkViewController = RequestWorkViewController()
            requestWorkViewController.location = mapView.centerCoordinate
            requestWorkViewController.isFirst = false
            requestWorkViewController.message = "ここで荷物を下ろす"
            self.navigationController!.pushViewController(requestWorkViewController, animated: true)
        }
        else
        {
            let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
            let requestFromViewController = stroBoardMain.instantiateViewControllerWithIdentifier("RequestFormViewController") as! RequestFormViewController
            requestFromViewController.startLocation = location
            requestFromViewController.endLocation = mapView.centerCoordinate
            requestFromViewController.isLook = false
            requestFromViewController.iswork = true
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
        
        placeAutocomplete(searchText)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.searchTableView.hidden = false
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = false
        self.navigationItem.leftBarButtonItem = backbutton
        self.searchBar.resignFirstResponder()
        self.searchTableView.hidden = true
        return true
    }
    
    // Cancelボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchTableView.hidden = true
        self.searchItem = []
        self.searchTableView.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    // Searchボタンが押された時に呼ばれる
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.view.endEditing(true)
        if(self.searchItem.count > 1)
        {
            mapView.setCenterCoordinate(self.searchItem[0].placemark.coordinate , animated: true)
            searchTableView.hidden = true
            searchItem = []
            searchTableView.reloadData()
        }
        
    }
    
    /*
     Cellが選択された際に呼び出されるデリゲートメソッド.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mapView.setCenterCoordinate(self.searchItem[indexPath.row].placemark.coordinate , animated: true)
        searchTableView.hidden = true
        searchItem = []
        searchTableView.reloadData()
        self.searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItem.count
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = searchItem[indexPath.row].name
        
        return cell
    }
    func placeAutocomplete(str:String) {
        
        let myRequest: MKLocalSearchRequest = MKLocalSearchRequest()
        myRequest.region = mapView.region
        myRequest.naturalLanguageQuery = str
        let mySearch: MKLocalSearch = MKLocalSearch(request: myRequest)
        
        // 検索開始.
        mySearch.startWithCompletionHandler { (response, error) -> Void in
            
            if error != nil {
                print("地名無し")
            }
            else if response!.mapItems.count > 0 {
                for item in response!.mapItems {
                    
                    // 検索結果の内名前を出力.
                    print(item.name)
                }
                self.searchItem = response!.mapItems
                self.searchTableView.reloadData()
            }
        }
    }
}