//
//  CustomTabBarController.swift
//  Escape
//
//  Created by Rahul Meena on 23/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum EscapeTabs:Int {
    case Home=0, Discover, Notifications, MyAccount
}

class CustomTabBarController: UIViewController {
    
    private var tabbedViewControllers: [UIViewController] = []
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var myAccountButton: UIButton!
    @IBOutlet weak var tabBarBottomConstraint: NSLayoutConstraint!
    
    var currentDisplayIndex = 0
    
    var shouldBeBlack = true
    
    var tabBarHidden:Bool = false {
        didSet {
            
            if tabBarHidden {
                tabBarBottomConstraint.constant = -80
            } else {
                tabBarBottomConstraint.constant = 0
            }
            
            UIView.animateWithDuration(0.15) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    var viewControllers: [UIViewController]  {
        get {
            let immutableCopy = tabbedViewControllers
            return immutableCopy
        }
        set {
            tabbedViewControllers = newValue
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViewControllers()
        
    }
    
    var activeViewController: UIViewController? {
        didSet {
            changeActiveViewControllerFrom(oldValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabIndexActive(0)
        
        self.tabBarView.layer.shadowColor   = UIColor.grayColor().CGColor
        self.tabBarView.layer.shadowRadius  = 2
        self.tabBarView.layer.shadowOffset  = CGSize(width: 0, height: 0)
        self.tabBarView.layer.shadowOpacity = 0.50
        self.tabBarView.layer.shadowPath = UIBezierPath(rect: self.tabBarView.bounds).CGPath
    }
    
    
    
    func setupViewControllers() {
        
        let homeViewController = initialViewControllerFor(.Home) as! CustomNavigationViewController
        let discoverViewController = initialViewControllerFor(.Discover) as! CustomNavigationViewController
        let notificationsViewController = initialViewControllerFor(.Notifications) as! CustomNavigationViewController
        let myAccountViewController = initialViewControllerFor(.MyAccount) as! CustomNavigationViewController
        
        viewControllers = [homeViewController, discoverViewController, notificationsViewController, myAccountViewController]
        
    }
    
    @IBAction func tappedOnTabWithSender(sender: UIButton) {
        setTabIndexActive(sender.tag)
    }
    
    func setTabIndexActive(index: Int) {
        
        currentDisplayIndex = index
        activeViewController = tabbedViewControllers[currentDisplayIndex]
        
        if let selectedTab = EscapeTabs(rawValue: index) {
            homeButton.selected = false
            discoverButton.selected = false
            notificationsButton.selected = false
            myAccountButton.selected = false
            
            switch selectedTab {
            case .Home:
                homeButton.selected = true
                break
            case .Discover:
                discoverButton.selected = true
                break
            case .Notifications:
                notificationsButton.selected = true
                break
            case .MyAccount:
                myAccountButton.selected = true
                break
            }
        }
        
    }
    
    func hideTabBar(hide: Bool) {
        if self.tabBarHidden == hide {
            return
        }
        
        self.tabBarHidden = hide
        
    }
    
    private func initialViewControllerFor(storyboardId: StoryBoardIdentifier) -> UIViewController? {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
    private func changeActiveViewControllerFrom(inactiveViewController:UIViewController?) {
        if isViewLoaded() {
            
            if let activeVC = activeViewController {
                
                if let inActiveVC = inactiveViewController {
                    inActiveVC.willMoveToParentViewController(nil)
                    
                    inActiveVC.view.removeFromSuperview()
                    inActiveVC.removeFromParentViewController()
                }
                
                addChildViewController(activeVC)
                
                activeVC.view.frame   = self.contentView.bounds
                contentView!.addSubview(activeVC.view)
                activeVC.didMoveToParentViewController(self)
                
            }
            
        }
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if shouldBeBlack {
            return .Default
        }
        return .LightContent
    }

}
