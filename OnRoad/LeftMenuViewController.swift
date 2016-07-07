//
//  LeftViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/30.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class LeftMenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var tableView: UITableView!
    
    var myUser = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width * 0.65, self.view.frame.height), style: .Plain)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.registerClass(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        
        tableView.separatorColor = UIColor.clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelectionDuringEditing = false
        tableView.scrollEnabled = false
        
        self.view.addSubview(tableView)
        
        myUser.id = UserDefaults.userId
        myUser.username = UserDefaults.userName
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //ヘッダーの高さを返す
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 && section < 5{
            return 1
        }else{
            return 0
        }
    }
    // tableviewのヘッダー
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let border = UIView(frame:CGRectMake(0,0,self.view.frame.width,1))
        border.backgroundColor = UIColor(red: 29/255,green: 28/255, blue:38/255, alpha:0.10)
        
        let white = UIView(frame:CGRectMake(0,0,15,1))
        white.backgroundColor = UIColor.whiteColor()
        border.addSubview(white)
        return border
    }
    
    // セクションの数を返す.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    
    // Cellが選択された際に呼び出されるデリゲートメソッド.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0
        {
            self.slideMenuController()?.closeLeft()
            
//            let notification : NSNotification = NSNotification(name: "segueProfileView", object: self, userInfo: nil)
//            NSNotificationCenter.defaultCenter().postNotification(notification)
            
        }
        else if indexPath.section == 1
        {
            self.slideMenuController()?.closeLeft()

            let notification : NSNotification = NSNotification(name: "segueRequestWorkView", object: self, userInfo: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
        else if indexPath.section == 2
        {
            self.slideMenuController()?.closeLeft()
            //
            //            let notification : NSNotification = NSNotification(name: "segueSearchView", object: self, userInfo: nil)
            //            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
        else if indexPath.section == 3
        {
//            let notification : NSNotification = NSNotification(name: "tagNotification", object: self, userInfo: ["tag": tags[indexPath.row].tag!])
//            NSNotificationCenter.defaultCenter().postNotification(notification)
            
            self.slideMenuController()?.closeLeft()
        }
        
    }
    
    
    // Cellの総数を返すデータソースメソッド.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else if section == 1
        {
            return 1
        }
        else if section == 2
        {
            return 1
        }
        else if section == 3
        {
            return 1
        }
        else if section == 4
        {
            return 1
        }
        return 0
    }
    // tableの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0
        {
            return 170
        }
        else if indexPath.row == 0 && indexPath.section == 1
        {
            return 93
        }
        else
        {
            return 60
        }
    }
    
    
    // Cellに値を設定するデータソースメソッド.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Cellに値を設定する.
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell",forIndexPath: indexPath) as! ProfileCell
            cell.setCell(myUser)
            cell.backgroundColor = Color.green
            return cell
        }
        else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
            cell.textLabel?.text = "仕事を登録"
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            return cell
        }
        else if indexPath.section == 2 && indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
            cell.textLabel?.text = "登録した仕事"
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            return cell
        }
        else if indexPath.section == 3 && indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
            cell.textLabel?.text = "設定"
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            return cell
        }
        else if indexPath.section == 4 && indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
            cell.textLabel?.text = "アプリを評価する"
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
            cell.textLabel?.text = "  "
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            return cell
        }
    }
}