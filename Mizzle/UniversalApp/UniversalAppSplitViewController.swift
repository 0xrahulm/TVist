//
//  UniversalAppSplitViewController.swift
//  TVist
//
//  Created by Rahul Meena on 09/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UniversalAppSplitViewController: UISplitViewController {

    var isRegular: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredDisplayMode = .allVisible
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for vc in self.viewControllers {
            if let genericNavVC = vc as? CustomNavigationViewController, let genericMasterVC = genericNavVC.topViewController as? GenericDetailViewController {
                genericMasterVC.displayModeButtonItem = self.displayModeButtonItem
            }
            
            if let genericDetailVC = vc as? GenericDetailViewController {
                genericDetailVC.displayModeButtonItem = self.displayModeButtonItem
            }
        }
    }
    
    func splitViewWith(primaryVC: UIViewController, secondaryVC: UIViewController) {
        self.viewControllers = [primaryVC, prepareDetailView(viewController: secondaryVC, addDisplayModeButtonItem: false)]
    }
    
    func changePrimaryViewController(viewController: UIViewController) {
        self.show(viewController, sender: self)
    }
    
    func changeSecondaryViewController(viewController: UIViewController) {
        
        let detailVC = prepareDetailView(viewController: viewController, addDisplayModeButtonItem: true)
        
        if self.viewControllers.count == 1 && self.isCollapsed {
         
            if let navVC = self.viewControllers[0] as? CustomNavigationViewController {
                navVC.pushViewController(detailVC, animated: true)
            }
        } else {
            
            self.showDetailViewController(detailVC, sender: self)
            
        }
    }
    
    func prepareDetailView(viewController: UIViewController, addDisplayModeButtonItem: Bool) -> UIViewController {
        
        var secondaryViewController = viewController
        if let genericDetailVC = secondaryViewController as? GenericDetailViewController {
            genericDetailVC.displayModeButtonItem = self.displayModeButtonItem
            genericDetailVC.isCollapsed = self.isCollapsed
            genericDetailVC.isRegular = self.isRegular
        }
        
        if self.isRegular {
            secondaryViewController = wrapInsideCustomNav(viewController: secondaryViewController)
        }
        
        return secondaryViewController
    }
    
    func wrapInsideCustomNav(viewController: UIViewController) -> CustomNavigationViewController {
        let customNav = CustomNavigationViewController(rootViewController: viewController)
        customNav.setNavigationBarHidden(true, animated: false)
        return customNav
    }

}

extension UniversalAppSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        
        for vc in svc.viewControllers {
            if let genericNavVC = vc as? CustomNavigationViewController, let genericMasterVC = genericNavVC.topViewController as? GenericDetailViewController {
                
                if displayMode == .primaryHidden {
                    genericMasterVC.enableProfileBackButton()
                } else if displayMode == .primaryOverlay || displayMode == .allVisible {
                    genericMasterVC.enableResizerButton()
                }
            }
        }
    }
    
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        if svc.displayMode == .primaryHidden || svc.displayMode == .primaryOverlay {
            return .allVisible
        }
        return .primaryHidden
    }
}
