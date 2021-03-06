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
    let applicationkey = "test"
    let clientkey      = "test"
    let cGoogleMapsAPIKey = "test"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // NCMB SDKの初期化
        NCMB.setApplicationKey(applicationkey, clientKey: clientkey)
        
        // Google Mapsの初期設定
        GMSServices.provideAPIKey(cGoogleMapsAPIKey)
        
        //navigationbar
        UINavigationBar.appearance().barTintColor = Color.green
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.00)]
        
        // ViewControllerを生成する.
        let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.userId != nil
        {
            let myFirstViewController = stroBoardMain.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            //        let myFirstViewController = stroBoardMain.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
            
            let myNavigationController: UINavigationController = UINavigationController(rootViewController: myFirstViewController)
            let slideMenuController = SlideMenuController(mainViewController: myNavigationController, leftMenuViewController: LeftMenuViewController())
            let controller = slideMenuController
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = controller
        }
        else
        {
            let myFirstViewController = stroBoardMain.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = myFirstViewController
        }
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

