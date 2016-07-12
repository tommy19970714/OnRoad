//
//  FirstViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/13.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController{
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickLoginButton(sender: UIButton) {
        let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = stroBoardMain.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: loginViewController)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    @IBAction func clickSignupButton(sender: UIButton) {
        let stroBoardMain = UIStoryboard(name: "Main", bundle: nil)
        let signupViewController = stroBoardMain.instantiateViewControllerWithIdentifier("SignupViewController") as! SignupViewController
        let nav = UINavigationController(rootViewController: signupViewController)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
}