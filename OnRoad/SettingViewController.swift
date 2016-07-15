//
//  SettingViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/26.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController{
    
    @IBOutlet weak var textField: UITextField!
    var myDatePicker: UIDatePicker!
    var toolBar:UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 入力欄の設定
        textField.placeholder = dateToString(NSDate())
        textField.text        = dateToString(NSDate())
        self.view.addSubview(textField)
        
        // UIDatePickerの設定
        myDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action: #selector(SettingViewController.changedDateEvent(_:)), forControlEvents: UIControlEvents.ValueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = myDatePicker
        
        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        
        let toolBarBtn      = UIBarButtonItem(title: "完了", style: .Bordered, target: self, action: #selector(SettingViewController.tappedToolBarBtn(_:)))
        let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .Bordered, target: self, action: #selector(SettingViewController.tappedToolBarBtnToday(_:)))
        
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtn, toolBarBtnToday]
        
        textField.inputAccessoryView = toolBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapedButton(sender: AnyObject) {
        AlertHelper.showOkAlert("しばらくお待ちください", message: "アップロードに時間がかかります", parent: self)
        let saveModel = SaveJsonModel(str: dateToString(myDatePicker.date))
        saveModel.getJson(dateToString(myDatePicker.date),callback: {success in
            if success == false
            {
                AlertHelper.showOkAlert("エラー", message: "保存に失敗しました．", parent: self)
            }
            else
            {
                AlertHelper.showOkAlert("保存", message: "保存しました．", parent: self)
            }
        })
    }
    @IBAction func tappedCheckButton(sender: UIButton) {
        let saveModel = SaveJsonModel(str: dateToString(myDatePicker.date))
        saveModel.checkSaved(dateToString(myDatePicker.date), callback: {success in
            if success == true
            {
                AlertHelper.showOkAlert("チェック", message: "存在します", parent: self)
            }
            else if success == false
            {
                AlertHelper.showOkAlert("チェック", message: "存在しません", parent: self)
            }
            else
            {
                AlertHelper.showOkAlert("エラー", message: "アクセスできません", parent: self)
            }
        })
        
    }
    
    
    // 「完了」を押すと閉じる
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
    }
    
    // 「今日」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        myDatePicker.date = NSDate()
        changeLabelDate(NSDate())
    }
    
    func changedDateEvent(sender:UIDatePicker){
        let dateSelecter = sender as UIDatePicker
        self.changeLabelDate(myDatePicker.date)
    }
    
    func changeLabelDate(date:NSDate) {
        textField.text = self.dateToString(date)
    }
    
    func dateToString(date:NSDate) ->String {
        
        let dateformatter = NSDateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: NSLocaleLanguageCode)
        dateformatter.dateFormat = "yyyy/MM/dd"
        let str = dateformatter.stringFromDate(date)
        
        return str.stringByReplacingOccurrencesOfString("/", withString: "-", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
    }
    
}

