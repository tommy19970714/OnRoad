//
//  ProfileCell.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/30.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    var name: UILabel!
    var profileIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(user :User) {
        
        name = UILabel(frame: CGRectMake(self.frame.width/2-50, 26, 100, 35))
        name.text = user.username
        name.font = UIFont.systemFontOfSize(23)
        name.textAlignment = NSTextAlignment.Center
        self.addSubview(name)
        
//        profileIcon = UIImageView(frame: CGRectMake(self.frame.width/2-50,25 , 100, 100))
//        profileIcon.sd_setImageWithURL(NSURL(string: user.profile_picture!))
//        profileIcon.image = UIImage(named: "3")
//        profileIcon.layer.cornerRadius = profileIcon.frame.size.width / 2.0
//        profileIcon.layer.masksToBounds = true
//        self.addSubview(profileIcon)
    }
    
}