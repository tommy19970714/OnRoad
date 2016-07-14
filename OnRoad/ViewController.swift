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
    
    //reviewのURL
    let itunesURL:String = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1134663266"
    //忘れない！
    
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
    @IBOutlet weak var button6: CustomUIButton!
    
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
        button1.setIcon("コメント")
        button2.setIcon("仕事")
        button3.setIcon("食事処")
        button4.setIcon("ガソリンスタンド")
        button5.setIcon("パーキング")
        button6.setIcon("コンビニ")
        
        
        menubutton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(ViewController.clickMenu(_:)))
        self.navigationItem.leftBarButtonItem = menubutton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.segueRequestWorkView(_:)), name: "segueRequestWorkView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.segueWorkListView(_:)), name: "segueWorkListView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.review(_:)), name: "review", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.signout(_:)), name: "signout", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.postComment(_:)), name: "postComment", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.segueCommentListView(_:)), name: "segueCommentListView", object: nil)

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
    @IBAction func tappedPostComment(sender: UIButton) {
        post()
    }
    
    @IBAction func tappedButton0(sender: CustomUIButton) {
        changeType(sender, type: Types.opendata.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton1(sender: CustomUIButton) {
        changeType(sender, type: Types.comment.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton2(sender: CustomUIButton) {
        changeType(sender, type: Types.workdata.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton3(sender: CustomUIButton) {
        changeType(sender, type: Types.restaurant.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton4(sender: CustomUIButton) {
        changeType(sender, type: Types.gas_station.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton5(sender: CustomUIButton) {
        changeType(sender, type: Types.parking.rawValue)
        sender.changeSw()
    }
    @IBAction func tappedButton6(sender: CustomUIButton) {
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
        DataListModel.sharedInstance.update(mapView.region, types: types)
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
    func postComment(sender:NSNotification) {
        post()
    }
    func post()
    {
        let requestWorkViewController = RequestWorkViewController()
        requestWorkViewController.message = "ここに口コミを書く"
        requestWorkViewController.isWork = false
        let nav = UINavigationController(rootViewController: requestWorkViewController)
        self.presentViewController(nav, animated: true, completion: nil)
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
        workListViewController.iswork = true
        let nav = UINavigationController(rootViewController: workListViewController)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func segueCommentListView(sender:NSNotification)
    {
        let workListViewController = WorkListViewController()
        workListViewController.iswork = false
        let nav = UINavigationController(rootViewController: workListViewController)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func review(sender:NSNotification) {
        let url = NSURL(string:itunesURL)
        let app:UIApplication = UIApplication.sharedApplication()
        app.openURL(url!)
    }
    
    func signout(sender:NSNotification) {
        
        AlertHelper.showAlert("サインアウト", message: "本当にサインアウトしますか？", cancel: "キャンセル", destructive: nil, others: ["OK"], parent: self) {
            (buttonIndex: Int) in
            // 押されたボタンのインデックスにて処理を振り分ける
            switch buttonIndex {
            case 1 :
                // OK
                let ud3 = NSUserDefaults.standardUserDefaults()
                ud3.removeObjectForKey("userId")
                ud3.removeObjectForKey("userName")
                ud3.removeObjectForKey("mail")
                
                let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
                let viewController = stroBoardMain.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController
                
                self.presentViewController(viewController, animated: true, completion: nil)
                break
            default :
                // キャンセル
                break
            }
        }
    }
    
    func clickDetailButton(sender:UIButton)
    {
        let customDetailButtom = sender as! CustomDetailButton
        
        if customDetailButtom.dataList?.type == Types.workdata.rawValue || customDetailButtom.dataList?.type == Types.comment.rawValue
        {
            let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
            let detailWorkViewController = stroBoardMain.instantiateViewControllerWithIdentifier("RequestFormViewController") as! RequestFormViewController
            detailWorkViewController.objectId = customDetailButtom.dataList?.objectId
            detailWorkViewController.firstText = customDetailButtom.dataList?.text
            detailWorkViewController.firstTitle = customDetailButtom.dataList?.title
            detailWorkViewController.iswork = true
            detailWorkViewController.isLook = true
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