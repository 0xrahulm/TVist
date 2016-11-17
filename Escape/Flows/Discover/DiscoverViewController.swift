//
//  DiscoverViewController.swift
//  Escape
//
//  Created by Ankit on 29/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import ionicons

class DiscoverViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var containerView: UIView!
    
    var controllerArray : [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Discover"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let searchImage = IonIcons.imageWithIcon(ion_ios_search, size: 30, color: UIColor.themeColorBlack())
        
        let addImage = IonIcons.imageWithIcon(ion_ios_personadd, size: 30, color: UIColor.themeColorBlack())
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DiscoverViewController.didTapGoToRight))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: addImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DiscoverViewController.didTapGoToLeft))
        
        
        configureVCs()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
            .SelectionIndicatorColor(UIColor.escapeBlueColor()),
            .BottomMenuHairlineColor(UIColor.textGrayColor()),
            .MenuItemFont(UIFont(name: "SFUIDisplay-SemiBold", size: 15.0)!),
            .MenuHeight(45.0),
            .MenuMargin(0.0),
            .MenuItemWidth(100.0),
            .CenterMenuItems(true),
            .SelectedMenuItemLabelColor(UIColor.themeColorBlack()),
            .UnselectedMenuItemLabelColor(UIColor.textGrayColor()),
            .SelectionIndicatorHeight(1.5)
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
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
        ScreenVader.sharedVader.performScreenManagerAction(.OpenAddToEscapeView, queryParams: nil)
//        let currentIndex = pageMenu!.currentPageIndex
//        
//        if currentIndex > 0 {
//            pageMenu!.moveToPage(currentIndex - 1)
//        }
    }
    
    func didTapGoToRight() {
        ScreenVader.sharedVader.performScreenManagerAction(.OpenSearchView, queryParams: nil)
       
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

 //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DiscoverViewController.didTapGoToRight))


// MARK: - Scroll menu setup
