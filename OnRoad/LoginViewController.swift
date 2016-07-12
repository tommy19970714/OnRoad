//
//  LoginViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/13.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var backbutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        backbutton = UIBarButtonItem(image: UIImage(named: "closemenu"), style: .Plain, target: self, action: #selector(LoginViewController.backHome(_:)))
        self.navigationItem.leftBarButtonItem = backbutton
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickLogin(sender: UIButton) {
        
    }
    func backHome(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}