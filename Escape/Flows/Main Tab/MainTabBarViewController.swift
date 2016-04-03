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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        appearTabBar()
    }
    
    func setTabBarAppearance(){
        
        self.tabBar.layer.shadowColor   = UIColor.grayColor().CGColor
        self.tabBar.layer.shadowRadius  = 2
        self.tabBar.layer.shadowOffset  = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowOpacity = 0.50
        self.tabBar.layer.shadowPath = UIBezierPath(rect: self.tabBar.bounds).CGPath
        
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
