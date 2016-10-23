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
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var myAccountButton: UIButton!
    
    var currentDisplayIndex = 0
    
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
    
    
    private func initialViewControllerFor(storyboardId: StoryBoardIdentifier) -> UIViewController? {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
    private func changeActiveViewControllerFrom(inactiveViewController:UIViewController?) {
        if isViewLoaded() {
            let width = CGRectGetWidth(contentView!.frame)
            let height = CGRectGetHeight(contentView!.frame)
            
            if let inActiveVC = inactiveViewController {
                inActiveVC.willMoveToParentViewController(nil)
                
                if let activeVC = activeViewController {
                    var offSet = -width
                    if tabbedViewControllers.indexOf(activeVC) > tabbedViewControllers.indexOf(inActiveVC) {
                        offSet = width
                    }
                    activeVC.view.frame = CGRectMake(offSet, 0, width, height)
                    
                    //disabling segment till animation is completed
                    
                    addChildViewController(activeVC)
                    
                    
                    transitionFromViewController(inActiveVC, toViewController: activeVC, duration: 0.2, options: UIViewAnimationOptions.AllowAnimatedContent,
                                                 animations: { [unowned self] () -> Void in
                                                    inActiveVC.view.frame = CGRectMake(-offSet, 0, width, height)
                                                    inActiveVC.view.alpha = 0
                                                    activeVC.view.frame   = self.contentView.bounds
                        }, completion: { [unowned self] (finished) -> Void in
                            activeVC.didMoveToParentViewController(self)
                            
                        })
                    
                    activeVC.view.visibleWithAnimationDuration(0.15)
                }
                
            } else {
                
                if let activeVC = activeViewController {
                    addChildViewController(activeVC)
                    activeVC.view.frame = contentView!.bounds
                    contentView!.addSubview(activeVC.view)
                    activeVC.didMoveToParentViewController(self)
                    activeVC.view.visibleWithAnimationDuration(0.15)
                }
            }
            
        }
    }
    

}
