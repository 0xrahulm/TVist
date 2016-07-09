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
    
    var controllerArray : [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Discover"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        configureVCs()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //configureVCs()
    }
    
    func configureVCs(){
        
        // Initialize view controllers to display and place in array
       
        addVcFor(.All, title: "All")
        addVcFor(.Movie, title: "Movies")
        addVcFor(.TvShows, title: "Tv Shows")
        addVcFor(.Books, title: "Books")
        addVcFor(.People, title: "People")
        
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64, self.view.frame.width, self.view.frame.height-64), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
        
    }
    
    func addVcFor(type : DiscoverType , title : String){
        let controller = UIStoryboard(name: "Discover", bundle: nil).instantiateViewControllerWithIdentifier("DiscoverAllVC") as? DiscoverAllViewController
        controller!.title = title
        controller!.type = type
        controllerArray.append(controller!)
        
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

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DiscoverViewController.didTapGoToLeft))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DiscoverViewController.didTapGoToRight))

// MARK: - Scroll menu setup
