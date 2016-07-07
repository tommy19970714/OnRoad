//
//  AlertHelper.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/07.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    
    class func showAlert (title: String?, message: String?, cancel: String?, destructive: [String]?, others: [String]?, parent: UIViewController, callback: (Int) -> ()) {
        
        // アラート要素が全てnilの場合は中止
        if title == nil && message == nil && cancel == nil && destructive == nil && others == nil {
            return
        }
        
        // アラート作成
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // キャンセルボタン処理
        if cancel != nil {
            let cancelAction = UIAlertAction(title: cancel!, style: .Cancel) {
                action in callback(0)
            }
            alertController.addAction(cancelAction)
        }
        
        let destructivOffset = 1
        var othersOffset = destructivOffset
        
        // Destructiveボタン処理
        if destructive != nil {
            for i in 0..<destructive!.count {
                let destructiveAction = UIAlertAction(title: destructive![i], style: .Destructive) {
                    action in callback(i + destructivOffset)
                }
                alertController.addAction(destructiveAction)
                
                othersOffset += 1
            }
        }
        
        // その他ボタン処理
        if others != nil {
            for i in 0..<others!.count {
                let otherAction = UIAlertAction(title: others![i], style: .Default) {
                    action in callback(i + othersOffset)
                }
                alertController.addAction(otherAction)
            }
        }
        
        // アラート表示
        parent.presentViewController(alertController, animated: true, completion: nil)
    }
}