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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let searchImage = IonIcons.image(withIcon: ion_ios_search, size: 30, color: UIColor.themeColorBlack())
        
        //let addImage = IonIcons.imageWithIcon(ion_ios_personadd, size: 30, color: UIColor.themeColorBlack())
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(DiscoverViewController.didTapGoToRight))
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: addImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DiscoverViewController.didTapGoToLeft))
        
        
        configureVCs()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func configureVCs(){
        
        // Initialize view controllers to display and place in array
       
        addVcFor(.All, title: "ALL")
        addVcFor(.Movie, title: "MOVIES")
        addVcFor(.TvShows, title: "TV SHOWS")
        addVcFor(.Books, title: "BOOKS")
        addVcFor(.People, title: "PEOPLE")
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.escapeBlueColor()),
            .bottomMenuHairlineColor(UIColor.textGrayColor()),
            .menuItemFont(UIFont(name: "SFUIDisplay-Regular", size: 13.0)!),
            .menuHeight(45.0),
            .menuMargin(0.0),
            .menuItemWidth(100.0),
            .centerMenuItems(true),
            .selectedMenuItemLabelColor(UIColor.themeColorBlack()),
            .unselectedMenuItemLabelColor(UIColor.textGrayColor()),
            .selectionIndicatorHeight(1.5)
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        
    }
    
    func addVcFor(_ type : DiscoverType , title : String){
        let controller = UIStoryboard(name: "Discover", bundle: nil).instantiateViewController(withIdentifier: "DiscoverAllVC") as? DiscoverAllViewController
        controller!.title = title
        controller!.type = type
        controllerArray.append(controller!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapGoToLeft() {
        
//        let currentIndex = pageMenu!.currentPageIndex
//        
//        if currentIndex > 0 {
//            pageMenu!.moveToPage(currentIndex - 1)
//        }
    }
    
    func didTapGoToRight() {
        AnalyticsVader.sharedVader.basicEvents(eventName: .SearchOnDiscoverTapped)
        ScreenVader.sharedVader.performScreenManagerAction(.OpenSearchView, queryParams: ["screen" : "discover"])
    }
    
    // MARK: - Container View Controller
    override var shouldAutomaticallyForwardAppearanceMethods : Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
}


//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DiscoverViewController.didTapGoToLeft))

 //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DiscoverViewController.didTapGoToRight))


// MARK: - Scroll menu setup
