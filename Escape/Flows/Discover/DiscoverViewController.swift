//
//  DiscoverViewController.swift
//  Escape
//
//  Created by Ankit on 29/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
       
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = "Discover"
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DiscoverViewController.didTapGoToLeft))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DiscoverViewController.didTapGoToRight))
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 = UIStoryboard(name: "Discover", bundle: nil).instantiateViewControllerWithIdentifier("DiscoverAllVC") as? DiscoverAllViewController
       
        controller1!.title = "All"
        controllerArray.append(controller1!)
        
        let controller2  = UIStoryboard(name: "Discover", bundle: nil).instantiateViewControllerWithIdentifier("DiscoverAllVC") as? DiscoverAllViewController
        controller2!.title = "Movies"
        controllerArray.append(controller2!)
        
        let controller3 = UIStoryboard(name: "Discover", bundle: nil).instantiateViewControllerWithIdentifier("DiscoverAllVC") as? DiscoverAllViewController
        
        controller3!.title = "Tv Shows"
        controllerArray.append(controller3!)
        
        let controller4 = UIStoryboard(name: "Discover", bundle: nil).instantiateViewControllerWithIdentifier("DiscoverAllVC") as? DiscoverAllViewController
        controller4!.title = "Books"
        controllerArray.append(controller4!)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.themeColorBlue()),
            .BottomMenuHairlineColor(UIColor.themeColorBlue()),
            .MenuItemFont(UIFont(name: "SFUIDisplay-Regular", size: 14.0)!),
            .MenuHeight(45.0),
            .MenuItemWidth(80.0),
            .CenterMenuItems(true),
            .SelectedMenuItemLabelColor(UIColor.themeColorBlue()),
            .UnselectedMenuItemLabelColor(UIColor.grayColor()),
            .SelectionIndicatorHeight(1.0),
            
            
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.containerView.addSubview(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
    
    // MARK: - Container View Controller
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    


}
