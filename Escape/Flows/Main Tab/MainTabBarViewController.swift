//
//  MainTabBarViewController.swift
//  Escape
//
//  Created by Ankit on 25/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

let kMainTabsCount = 5
enum MainTabIndex {
    case Home, Tracker, Listings, Search, Watchlist
    
    var index:Int {
        
        switch self {
        case .Home:
            return 0
        case .Tracker:
            return 1
        case .Listings:
            return 2
        case .Watchlist:
            return 3
        case .Search:
            return 4
        }
    }
    
}



class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var shouldBeBlack = true
    
    func getMainTabForIndex(index:Int) -> MainTabIndex? {
        if MainTabIndex.Home.index == index {
            return .Home
        }
        if MainTabIndex.Tracker.index == index {
            return .Tracker
        }
        if MainTabIndex.Listings.index == index {
            return .Listings
        }
        if MainTabIndex.Search.index == index {
            return .Search
        }
        if MainTabIndex.Watchlist.index == index {
            return .Watchlist
        }
        
        
        return nil
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UITabBar.appearance().shadowImage = UIImage()
        self.view.backgroundColor = UIColor.white
        setupViewControllers()
    }
    
    
    private func setupViewControllers() {
        
        
        let homeViewController = initialViewControllerFor(.Home) as! CustomNavigationViewController
        let searchViewController = initialViewControllerFor(.Search) as! CustomNavigationViewController
        let discoverViewController = initialViewControllerFor(.Listings) as! CustomNavigationViewController
        
        let trackerViewController = initialViewControllerFor(.Tracker) as! CustomNavigationViewController
        let watchlistViewController = initialViewControllerFor(.Watchlist) as! CustomNavigationViewController
        
        
        var orderedViewControllers:[UIViewController] = Array<UIViewController>(repeating: UIViewController(),count: kMainTabsCount)
        
        orderedViewControllers[MainTabIndex.Home.index] = homeViewController
        orderedViewControllers[MainTabIndex.Tracker.index] = trackerViewController
        orderedViewControllers[MainTabIndex.Listings.index] = discoverViewController
        orderedViewControllers[MainTabIndex.Search.index] = searchViewController
        orderedViewControllers[MainTabIndex.Watchlist.index] = watchlistViewController
        
        self.viewControllers = orderedViewControllers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarAppearance()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apparateTabBar()
    }
    
    func apparateTabBar() {
        var tabBarFrame = self.tabBar.frame
        tabBarFrame.origin.y = view.bounds.height
    }
    
    
    func getSelectedTabViewController() -> UIViewController {
        return self.viewControllers![self.selectedIndex]
    }
    
    fileprivate func initialViewControllerFor(_ storyboardId: StoryBoardIdentifier) -> UIViewController? {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
    func setTabBarAppearance(){
        
        self.tabBar.layer.shadowColor   = UIColor.gray.cgColor
        self.tabBar.layer.shadowRadius  = 2
        self.tabBar.layer.shadowOffset  = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowOpacity = 0.50
        self.tabBar.layer.shadowPath = UIBezierPath(rect: self.tabBar.bounds).cgPath
        
        self.tabBar.tintColor = UIColor.escapeBlueColor()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if shouldBeBlack {
            return .default
        }
        return .lightContent
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabItems = tabBar.items {
            if let index = tabItems.index(of: item) {
                
                if let getItem = getMainTabForIndex(index: index) {
                    switch getItem {
                    case .Home:
                        AnalyticsVader.sharedVader.basicEvents(eventName: .HomeTabClick)
                        break
                    case .Search:
                        AnalyticsVader.sharedVader.basicEvents(eventName: .SearchTabClick)
                        break
                    case .Listings:
                        AnalyticsVader.sharedVader.basicEvents(eventName: .ListingsTabClick)
                        break
                    case .Tracker:
                        AnalyticsVader.sharedVader.basicEvents(eventName: .TrackerTabClick)
                        break
                    case .Watchlist:
                        AnalyticsVader.sharedVader.basicEvents(eventName: .WatchlistTabClick)
                        break
                    }
                }
                
            }
        }
    }


}
