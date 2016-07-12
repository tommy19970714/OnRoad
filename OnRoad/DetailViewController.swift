//
//  DetailViewController.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/07/09.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    
    @IBOutlet weak var parkButton: UIButton!
    @IBOutlet weak var streetButton: UIButton!
    
    var location:CLLocationCoordinate2D?
    var placeId:String?
    var photoReference:String?
    var placetitle: String?
    var vicinity:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = placetitle
        addressLabel.text = vicinity
        streetButton.addTarget(self, action: #selector(DetailViewController.clickStreetView(_:)), forControlEvents: .TouchUpInside)
        
        let detailModel = GetDetailPlaceModel()
        detailModel.placeid = self.placeId
        detailModel.getDetail({opentime in
            if opentime == nil{
                self.timeLabel.text = "???"
            }else{
                self.timeLabel.text = opentime
            }
        })
        if photoReference != nil
        {
            let url = detailModel.getImage(photoReference!)
            imageView.sd_setImageWithURL(NSURL(string:url))
        }
        
    }
    
    func clickStreetView(sender:UIButton)
    {
        let streetViewController = StreetViewController()
        streetViewController.location = location
        self.navigationController!.pushViewController(streetViewController, animated: true)
    }
}