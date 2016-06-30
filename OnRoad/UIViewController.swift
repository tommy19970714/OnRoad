//
//  UIViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/29.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func instantiate() -> Self {
        return instantiate(self)
    }
    
    static func instantiateWithNav() -> Self {
        return instantiate(self)
    }
    
    private static func instantiate<T: UIViewController>(type: T.Type) -> T {
        let sn = NSStringFromClass(type).componentsSeparatedByString(".").last!
        let sb = UIStoryboard(name: sn, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(sn) as! T
        return vc
    }
    
    private static func instantiateWithNav<T: UIViewController>(type: T.Type) -> UINavigationController {
        let sn = NSStringFromClass(type).componentsSeparatedByString(".").last!
        let sb = UIStoryboard(name: sn, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(sn) as! T
        return UINavigationController(rootViewController: vc)
    }
}
