//
//  DemoPopupViewController3.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/9/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

class DemoPopupViewController3: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var closeButton:UIButton!
    
    var closeHandler: (() -> Void)?
    
    class func instance() -> DemoPopupViewController3 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController3", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("DemoPopupViewController3") as! DemoPopupViewController3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let storyboard = UIStoryboard(name: "DemoPopupViewController3", bundle: nil)
        let container1 = storyboard.instantiateViewControllerWithIdentifier("DemoPopupContainer1")
        let container2 = storyboard.instantiateViewControllerWithIdentifier("DemoPopupContainer2")
        let container3 = storyboard.instantiateViewControllerWithIdentifier("DemoPopupContainer3")
        let container4 = storyboard.instantiateViewControllerWithIdentifier("DemoPopupContainer4")
        let container5 = storyboard.instantiateViewControllerWithIdentifier("DemoPopupContainer5")
        
        container1.view.frame = UIScreen.mainScreen().bounds
        container2.view.frame = UIScreen.mainScreen().bounds
        container2.view.frame.origin.x = UIScreen.mainScreen().bounds.width
        container3.view.frame = UIScreen.mainScreen().bounds
        container3.view.frame.origin.x = UIScreen.mainScreen().bounds.width * 2
        container4.view.frame = UIScreen.mainScreen().bounds
        container4.view.frame.origin.x = UIScreen.mainScreen().bounds.width * 3
        container5.view.frame = UIScreen.mainScreen().bounds
        container5.view.frame.origin.x = UIScreen.mainScreen().bounds.width * 4
        
        self.addChildViewController(container1)
        scrollView.addSubview(container1.view)
        container1.didMoveToParentViewController(self)
        
        self.addChildViewController(container2)
        scrollView.addSubview(container2.view)
        container2.didMoveToParentViewController(self)
        
        self.addChildViewController(container3)
        scrollView.addSubview(container3.view)
        container3.didMoveToParentViewController(self)
        
        self.addChildViewController(container4)
        scrollView.addSubview(container4.view)
        container4.didMoveToParentViewController(self)
        
        self.addChildViewController(container5)
        scrollView.addSubview(container5.view)
        container5.didMoveToParentViewController(self)
        
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * 5, UIScreen.mainScreen().bounds.height)
        
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        
        closeButton.hidden = true
    }
    
    @IBAction func didTapCloseButton(sender: AnyObject) {
        closeHandler?()
    }
    
}

extension DemoPopupViewController3: PopupContentViewController {
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
}

extension DemoPopupViewController3: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor((scrollView.contentOffset.x / scrollView.frame.width)))
        print(pageControl.currentPage)
        if pageControl.currentPage == 4
        {
            self.closeButton.hidden = false
        }
        else
        {
            self.closeButton.hidden = true
        }
    }
}