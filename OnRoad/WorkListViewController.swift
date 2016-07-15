//
//  WorkListBiewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/11.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class WorkListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var tableView: UITableView!
    var backbutton: UIBarButtonItem!
    
    var works:[DataList] = []
    
    var iswork:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelectionDuringEditing = true
        tableView.rowHeight = 100
        
        self.view.addSubview(tableView)
        
        backbutton = UIBarButtonItem(image: UIImage(named: "closemenu"), style: .Plain, target: self, action: #selector(WorkListViewController.backHome(_:)))
        self.navigationItem.leftBarButtonItem = backbutton
        
        if iswork == true
        {
            let workDataModel = WorkDataModel()
            workDataModel.search({result in
                self.works = result
                self.tableView.reloadData()
            })
        }
        else
        {
            let commentDataModel = CommentDataModel()
            commentDataModel.search({result in
                self.works = result
                self.tableView.reloadData()
            })
        }
        
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
    
    func backHome(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Cellが選択された際に呼び出されるデリゲートメソッド.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
        let requestFromViewController = stroBoardMain.instantiateViewControllerWithIdentifier("RequestFormViewController") as! RequestFormViewController
        
        requestFromViewController.startLocation = works[indexPath.row].location
        requestFromViewController.endLocation = works[indexPath.row].endPoint
        requestFromViewController.firstText = works[indexPath.row].text
        requestFromViewController.firstTitle = works[indexPath.row].title
        requestFromViewController.objectId = works[indexPath.row].objectId
        requestFromViewController.isLook = false
        requestFromViewController.iswork = true
        self.navigationController!.pushViewController(requestFromViewController, animated: true)
    }
    
    
    // Cellの総数を返すデータソースメソッド.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.works.count
    }
    
    
    // Cellに値を設定するデータソースメソッド.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        cell.textLabel?.text = works[indexPath.row].title
        cell.detailTextLabel?.text = works[indexPath.row].text
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            AlertHelper.showAlert("削除", message: "投稿したデータを削除してもよいですか？", cancel: "キャンセル", destructive: nil, others: ["OK"], parent: self) {
                (buttonIndex: Int) in
                switch buttonIndex {
                case 1 :
                    // OK
                    if self.iswork == true {
                        let workDataModel = WorkDataModel()
                        workDataModel.deleteObject(self.works[indexPath.row],callback: { success in
                            if success == true
                            {
                                AlertHelper.showOkAlert("削除完了", message: "選択された投稿データは削除されました．", parent: self)
                                self.works.removeAtIndex(indexPath.row)
                                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                            }
                            else
                            {
                                AlertHelper.showOkAlert("エラー", message: "削除できませんでした．", parent: self)
                            }
                        })
                    }else{
                        let commentDataModel = CommentDataModel()
                        commentDataModel.deleteObject(self.works[indexPath.row],callback: { success in
                            if success == true
                            {
                                AlertHelper.showOkAlert("削除完了", message: "選択された投稿データは削除されました．", parent: self)
                                self.works.removeAtIndex(indexPath.row)
                                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                            }
                            else
                            {
                                AlertHelper.showOkAlert("エラー", message: "削除できませんでした．", parent: self)
                            }
                        })
                    }
                    break
                default :
                    // キャンセル
                    break
                }
            }

        }
    }
}