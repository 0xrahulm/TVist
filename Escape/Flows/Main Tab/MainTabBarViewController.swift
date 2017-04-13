//
//  MainTabBarViewController.swift
//  Escape
//
//  Created by Ankit on 25/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit


class MainTabBarViewController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarAppearance()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appearTabBar()
    }
    
    func setTabBarAppearance(){
        
        self.tabBar.layer.shadowColor   = UIColor.gray.cgColor
        self.tabBar.layer.shadowRadius  = 2
        self.tabBar.layer.shadowOffset  = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowOpacity = 0.50
        self.tabBar.layer.shadowPath = UIBezierPath(rect: self.tabBar.bounds).cgPath
        
        self.tabBar.tintColor = UIColor.escapeBlueColor()
        
        if let tabItems = self.tabBar.items {
            let tabItem1 = tabItems[0] as UITabBarItem
            let tabItem2 = tabItems[1] as UITabBarItem
            let tabItem3 = tabItems[2] as UITabBarItem
            //let tabItem4 = tabItems[3] as UITabBarItem
            //tabItem1.title = "Home"
            tabItem1.title = "Discover"
            tabItem2.title = "Search"
            tabItem3.title = "My Account"
        }
    }
    func appearTabBar() {
        var tabBarFrame = self.tabBar.frame
        tabBarFrame.origin.y = view.bounds.height
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
