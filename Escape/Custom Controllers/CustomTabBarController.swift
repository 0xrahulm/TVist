//
//  CustomTabBarController.swift
//  Escape
//
//  Created by Rahul Meena on 23/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UserNotifications
import UIKit

enum EscapeTabs:Int {
    case home=0, myAccount, search, discover
}

class CustomTabBarController: UIViewController {
    
    fileprivate var tabbedViewControllers: [UIViewController] = []
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
            
            UIView.animate(withDuration: 0.15, animations: {
                self.view.layoutIfNeeded()
            }) 
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
        
        self.tabBarView.layer.shadowColor   = UIColor.gray.cgColor
        self.tabBarView.layer.shadowRadius  = 2
        self.tabBarView.layer.shadowOffset  = CGSize(width: 0, height: 0)
        self.tabBarView.layer.shadowOpacity = 0.50
        self.tabBarView.layer.shadowPath = UIBezierPath(rect: self.tabBarView.bounds).cgPath
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupViewControllers() {
        
        let searchViewController = initialViewControllerFor(.Search) as! CustomNavigationViewController
        let discoverViewController = initialViewControllerFor(.Listings) as! CustomNavigationViewController
        let homeViewController = initialViewControllerFor(.TvGuide) as! CustomNavigationViewController
//        let notificationsViewController = initialViewControllerFor(.Notifications) as! CustomNavigationViewController
        let myAccountViewController = initialViewControllerFor(.MyAccount) as! CustomNavigationViewController
        
        viewControllers = [homeViewController, myAccountViewController, searchViewController, discoverViewController]
        
    }
    
    @IBAction func tappedOnTabWithSender(_ sender: UIButton) {
        setTabIndexActive(sender.tag)
    }
    
    func setTabIndexActive(_ index: Int) {
        
        currentDisplayIndex = index
        activeViewController = tabbedViewControllers[currentDisplayIndex]
        
        if let selectedTab = EscapeTabs(rawValue: index) {
            homeButton.isSelected = false
            discoverButton.isSelected = false
            notificationsButton.isSelected = false
            myAccountButton.isSelected = false
            
            
            switch selectedTab {
            case .search:
                
                notificationsButton.isSelected = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.HomeClickObserver.rawValue), object: nil)
                break
            case .discover:
                
                discoverButton.isSelected = true
                break
            case .home:
                homeButton.isSelected = true
                
                break
//            case .notifications:
//                notificationsButton.isSelected = true
//                break
            case .myAccount:
                
                myAccountButton.isSelected = true
                break
            }
            
//            AnalyticsVader.sharedVader.basicEvents(eventName: eventName)
        }
        
    }
    
    func hideTabBar(_ hide: Bool) {
        if self.tabBarHidden == hide {
            return
        }
        
        self.tabBarHidden = hide
        
    }
    
    fileprivate func initialViewControllerFor(_ storyboardId: StoryBoardIdentifier) -> UIViewController? {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
    fileprivate func changeActiveViewControllerFrom(_ inactiveViewController:UIViewController?) {
        if isViewLoaded {
            
            if let activeVC = activeViewController {
                
                if let inActiveVC = inactiveViewController {
                    inActiveVC.willMove(toParentViewController: nil)
                    
                    inActiveVC.view.removeFromSuperview()
                    inActiveVC.removeFromParentViewController()
                }
                
                addChildViewController(activeVC)
                
                activeVC.view.frame   = self.contentView.bounds
                contentView!.addSubview(activeVC.view)
                activeVC.didMove(toParentViewController: self)
                
            }
            
        }
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if shouldBeBlack {
            return .default
        }
        return .lightContent
    }

}
