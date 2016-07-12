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
import SlideMenuControllerSwift

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var searchBar: UISearchBar!
    var menubutton: UIBarButtonItem!
    
    var locationManager: CLLocationManager!
    var isloaded:Bool = false
//    var types : [String] = Types.allType
    var types:[String] = []
    
    var dataLists:[DataList] = []
    
    @IBOutlet weak var button0: CustomUIButton!
    @IBOutlet weak var button1: CustomUIButton!
    @IBOutlet weak var button2: CustomUIButton!
    @IBOutlet weak var button3: CustomUIButton!
    @IBOutlet weak var button4: CustomUIButton!
    @IBOutlet weak var button5: CustomUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataListModel.sharedInstance.addObserver(self, forKeyPath: "dataLists", options: [.New], context: nil)
        self.dataLists = DataListModel.sharedInstance.getData()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        
        setupSearchBar()
        
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
        button0.setIcon("Opendata")
        button1.setIcon("仕事")
        button2.setIcon("食事処")
        button3.setIcon("ガソリンスタンド")
        button4.setIcon("パーキング")
        button5.setIcon("コンビニ")
        
        menubutton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(ViewController.clickMenu(_:)))
        self.navigationItem.leftBarButtonItem = menubutton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.segueRequestWorkView(_:)), name: "segueRequestWorkView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.segueWorkListView(_:)), name: "segueWorkListView", object: nil)
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
    
    @IBAction func tappedButton0(sender: CustomUIButton) {
        changeType(sender, type: Types.opendata.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton1(sender: CustomUIButton) {
        changeType(sender, type: Types.workdata.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton2(sender: CustomUIButton) {
        changeType(sender, type: Types.restaurant.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton3(sender: CustomUIButton) {
        changeType(sender, type: Types.gas_station.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton4(sender: CustomUIButton) {
        changeType(sender, type: Types.parking.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton5(sender: CustomUIButton) {
        changeType(sender, type: Types.convenience_store.rawValue)
        sender.changeSw()
    }
    
    func changeType(sender:CustomUIButton,type:String)
    {
        if sender.getSw() == true
        {
            types.removeAtIndex(types.indexOf(type)!)
        }
        else
        {
            types.append(type)
        }
        print(types)
    }
    
    func clickMenu(sender:UIButton)
    {
        self.slideMenuController()?.openLeft()
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
        DataListModel.sharedInstance.update(mapView.region, types: types)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation === mapView.userLocation { // 現在地を示すアノテーションの場合はデフォルトのまま
            return nil
        }
        else
        {
            let myIdentifier = "myPin"
            
            var myAnnotation: MKAnnotationView!
            
            let customAnnotation = annotation as! CustomAnnotaion
            
            // annotationが見つからなかったら新しくannotationを生成.
            if myAnnotation == nil {
                myAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: myIdentifier)
                
                myAnnotation.canShowCallout = true
                
                let customCallout = CustomCalloutView(frame: CGRectMake(0,0,400,35))
                customCallout.enterButton.addTarget(self, action: #selector(ViewController.clickDetailButton(_:)), forControlEvents: .TouchUpInside)
                //値の受け渡し
                customCallout.enterButton.dataList = customAnnotation.dataList
                
                let widthConstraint = NSLayoutConstraint(item: customCallout, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
                customCallout.addConstraint(widthConstraint)
                
                let heightConstraint = NSLayoutConstraint(item: customCallout, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 38)
                customCallout.addConstraint(heightConstraint)
                myAnnotation.detailCalloutAccessoryView = customCallout
            }
            
            // 画像を選択.
            myAnnotation.image = customAnnotation.image
            myAnnotation.annotation = annotation

            return myAnnotation
        }
        
    }
    func mapView(mapView: MKMapView,annotationView view: MKAnnotationView,calloutAccessoryControlTapped control: UIControl)
    {
        
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "dataLists"{
            //ゲッタを使って変更を取得
            self.dataLists = DataListModel.sharedInstance.getData()
            mapView.removeAnnotations(mapView.annotations)
            for data in dataLists{
                let annotation = CustomAnnotaion()
                annotation.coordinate = data.location!
                annotation.title = data.title
                annotation.subtitle = data.getIntervalTime()
                annotation.dataList = data
                annotation.image = UIImage(named: data.type!)
                print(data.title)
                
                mapView.addAnnotation(annotation)
            }
        }
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
        self.navigationItem.leftBarButtonItem = menubutton
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueRequestWorkView(sender:NSNotification)
    {
        let requestWorkViewController = RequestWorkViewController()
        requestWorkViewController.message = "ここで荷物を積む"
        let nav = UINavigationController(rootViewController: requestWorkViewController)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func segueWorkListView(sender:NSNotification)
    {
        let workListViewController = WorkListViewController()
        let nav = UINavigationController(rootViewController: workListViewController)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func clickDetailButton(sender:UIButton)
    {
        let customDetailButtom = sender as! CustomDetailButton
        
        if customDetailButtom.dataList?.type == Types.workdata.rawValue
        {
            let detailWorkViewController = DetailWorkViewController()
            detailWorkViewController.objectId = customDetailButtom.dataList?.objectId
            detailWorkViewController.firstText = customDetailButtom.dataList?.text
            detailWorkViewController.firstTitle = customDetailButtom.dataList?.title
            self.navigationController!.pushViewController(detailWorkViewController, animated: true)
        }
        else if customDetailButtom.dataList?.type == Types.opendata.rawValue
        {
            let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = stroBoardMain.instantiateViewControllerWithIdentifier("DetailOpenDataViewController") as! DetailOpenDataViewController
            detailViewController.dataList = customDetailButtom.dataList
            self.navigationController!.pushViewController(detailViewController, animated: true)
        }
        else
        {
            let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = stroBoardMain.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            detailViewController.location = customDetailButtom.dataList!.location
            detailViewController.placetitle = customDetailButtom.dataList!.title
            detailViewController.placeId = customDetailButtom.dataList!.placeId
            detailViewController.photoReference = customDetailButtom.dataList!.photoReference
            detailViewController.vicinity = customDetailButtom.dataList!.vicinity
            
            self.navigationController!.pushViewController(detailViewController, animated: true)
        }
    }
}