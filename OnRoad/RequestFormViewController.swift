//
//  RequestFormViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class RequestFormViewController: UITableViewController, UITextFieldDelegate ,UITextViewDelegate{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var startLocation:CLLocationCoordinate2D!
    var endLocation:CLLocationCoordinate2D!
    
    var decideButton:UIBarButtonItem!
    
    var firstText:String? = "日時:\n\n積地:\n\n降地:\n\n料金:\n\n詳細:\n\n連絡先:\n\n"
    var firstTitle:String?
    
    var objectId:String?
    
    var isLook:Bool?
    var iswork:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView
        textView.delegate = self
        textView.text = firstText
        
        //textField
        textField.delegate = self
        textField.text = firstTitle
        
        textField.becomeFirstResponder()
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //navigationbar
        if isLook == false
        {
            if iswork == true
            {
                geocoting(startLocation, str: "積地:")
                geocoting(endLocation, str: "降地:")
            }

            decideButton = UIBarButtonItem(title: "決定", style: .Plain, target: self, action: #selector(RequestFormViewController.clickDecideButton(_:)))
            self.navigationItem.rightBarButtonItem = decideButton
        }
        else
        {
            textField.enabled = false
            textView.editable = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    func clickDecideButton(sender:UIButton)
    {
        if textField.text == nil || (textView.text == firstText)
        {
            AlertHelper.showAlert("アラート", message: "タイトル又は内容が入力されていません．", cancel: "ok", destructive: nil, others: nil, parent: self){
                (buttonIndex: Int) in
            }
            return
        }
        
        if iswork == true
        {
            let workDataModel = WorkDataModel()
            workDataModel.setParam(textField.text!,text: textView.text, startPoint: startLocation, endPoint: endLocation,objectId: objectId)
            AlertHelper.showAlert("送信", message: "選択した位置情報とコメントを送信しますがよろしいですか", cancel: "キャンセル", destructive: nil, others: ["OK"], parent: self) {
                (buttonIndex: Int) in
                switch buttonIndex {
                case 1 :
                    // OK
                    
                    workDataModel.save({ result -> Void in
                        
                        var message:String?
                        if result == true {
                            message = "送信されました！"
                        }else {
                            message = "送信できませんでした.ネットワーク状態を確認してください．"
                        }
                        AlertHelper.showAlert("送信完了", message: message!, cancel: "ok", destructive: nil, others: nil, parent: self) {
                            (buttonIndex: Int) in
                            // 押されたボタンのインデックスにて処理を振り分ける
                            switch buttonIndex {
                            default :
                                // キャンセル
                                break
                            }
                            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                        }
                    })
                    
                    break
                default :
                    // キャンセル
                    break
                }
            }
        }
        else
        {
            AlertHelper.showAlert("送信", message: "選択した位置情報とコメントを送信しますがよろしいですか", cancel: "キャンセル", destructive: nil, others: ["OK"], parent: self) {
                (buttonIndex: Int) in
                switch buttonIndex {
                case 1 :
                    // OK
                    
                    let commentDataModel = CommentDataModel()
                    commentDataModel.setParam(self.textField.text!,text: self.textView.text, location: self.startLocation, objectId: self.objectId)
                    commentDataModel.save({ result -> Void in
                        
                        var message:String?
                        if result == true {
                            message = "送信されました！"
                        }else {
                            message = "送信できませんでした."
                        }
                        AlertHelper.showAlert("アラート", message: message!, cancel: "ok", destructive: nil, others: nil, parent: self) {
                            (buttonIndex: Int) in
                            // 押されたボタンのインデックスにて処理を振り分ける
                            switch buttonIndex {
                            default :
                                // キャンセル
                                break
                            }
                            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                        }
                    })
                    
                    break
                default :
                    // キャンセル
                    break
                }
            }
        }

    }
    
    /*
     UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
     */
    func textFieldDidBeginEditing(textField: UITextField){

    }
    
    /*
     UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
     */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {

        
        return true
    }
    
    /*
     改行ボタンが押された際に呼ばれるデリゲートメソッド.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        if textField == self.textField {
            
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func geocoting(coordinate:CLLocationCoordinate2D,str:String) {
        // geocoderを作成.
        let myGeocorder = CLGeocoder()
        
        // locationを作成.
        let myLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // 逆ジオコーディング開始.
        myGeocorder.reverseGeocodeLocation(myLocation,
                                           completionHandler: { (placemarks, error) -> Void in
                                            
                                            for placemark in placemarks! {
                                                
                                                let address = (placemark.administrativeArea)! +  (placemark.locality)! +  (placemark.name)!
                                                self.textView.text = self.textView.text.stringByReplacingOccurrencesOfString(str, withString: str+"\n"+address, range: nil)
                                            }
        })
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0
        {
            return 60
        }
        else
        {
            if isLook == true
            {
                return 560
            }
            return 300
        }
    }
    
}