//
//  AppDelegate.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/26.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit
import NCMB
import GoogleMaps
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var myNavigationController: UINavigationController?
    
    //********** APIキーの設定 **********
    let applicationkey = "1da723c029fbce317b29a3888e237ec5d13cdada402e2ea0463a5b537980166f"
    let clientkey      = "110da5c45c1a4da41b5f7bf7f8ed871a6e7eb9e846ad6bf64d1360e88637ada4"
    let cGoogleMapsAPIKey = "AIzaSyB_XVDRakZ2Y9GgkDKkTu_imjHgHiPdsJY"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // NCMB SDKの初期化
        NCMB.setApplicationKey(applicationkey, clientKey: clientkey)
        
        // Google Mapsの初期設定
        GMSServices.provideAPIKey(cGoogleMapsAPIKey)
        
        // ViewControllerを生成する.
        let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
        let myFirstViewController : ViewController = stroBoardMain.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        // Navication Controllerを生成する.
        myNavigationController = UINavigationController(rootViewController: myFirstViewController)
        //横スライドメニュー作成
        let menuViewController = LeftViewController()
        let slideMenuController = SlideMenuController(mainViewController: myNavigationController!, leftMenuViewController: menuViewController)
        // UIWindowを生成する.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // rootViewControllerにNatigationControllerを設定する.
        self.window?.rootViewController = slideMenuController
        
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

