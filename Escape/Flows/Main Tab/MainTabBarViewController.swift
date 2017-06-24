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
    case Guide, Tracker, TopCharts, Search, Watchlist
    
    var index:Int {
        
        switch self {
        case .Guide:
            return 0
        case .Tracker:
            return 1
        case .TopCharts:
            return 2
        case .Search:
            return 3
        case .Watchlist:
            return 4
        }
    }
    
}



class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var shouldBeBlack = true
    
    func getMainTabForIndex(index:Int) -> MainTabIndex? {
        if MainTabIndex.Guide.index == index {
            return .Guide
        }
        if MainTabIndex.Tracker.index == index {
            return .Tracker
        }
        if MainTabIndex.TopCharts.index == index {
            return .TopCharts
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
        
        setupViewControllers()
    }
    
    
    private func setupViewControllers() {
        
        
        let searchViewController = initialViewControllerFor(.Search) as! CustomNavigationViewController
        let discoverViewController = initialViewControllerFor(.Discover) as! CustomNavigationViewController
        let homeViewController = initialViewControllerFor(.TvGuide) as! CustomNavigationViewController
        let trackerViewController = initialViewControllerFor(.Tracker) as! CustomNavigationViewController
        let myAccountViewController = initialViewControllerFor(.MyAccount) as! CustomNavigationViewController
        
        
        var orderedViewControllers:[UIViewController] = Array<UIViewController>(repeating: UIViewController(),count: kMainTabsCount)
        
        orderedViewControllers[MainTabIndex.Guide.index] = homeViewController
        orderedViewControllers[MainTabIndex.Tracker.index] = trackerViewController
        orderedViewControllers[MainTabIndex.TopCharts.index] = discoverViewController
        orderedViewControllers[MainTabIndex.Search.index] = searchViewController
        orderedViewControllers[MainTabIndex.Watchlist.index] = myAccountViewController
        
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
                    case .Guide:
                        AnalyticsVader.sharedVader.basicEvents(eventName: .GuideTabClick)
                        break
                    case .Search:
                        AnalyticsVader.sharedVader.basicEvents(eventName: .SearchTabClick)
                        break
                    case .TopCharts:
                        AnalyticsVader.sharedVader.basicEvents(eventName: .TopChartsTabClick)
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
