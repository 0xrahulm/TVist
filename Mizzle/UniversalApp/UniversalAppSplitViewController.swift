//
//  UniversalAppSplitViewController.swift
//  TVist
//
//  Created by Rahul Meena on 09/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UniversalAppSplitViewController: UISplitViewController {

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
        }
    }
    
    func splitViewWith(primaryVC: UIViewController, secondaryVC: UIViewController) {
        
        self.viewControllers = [primaryVC, secondaryVC]
    }
    
    func changePrimaryViewController(viewController: UIViewController) {
        self.show(viewController, sender: self)
    }
    
    func changeSecondaryViewController(viewController: UIViewController) {
        if let genericNavVC = viewController as? CustomNavigationViewController, let genericMasterVC = genericNavVC.topViewController as? GenericDetailViewController {
            genericMasterVC.displayModeButtonItem = self.displayModeButtonItem
        }
        
        self.showDetailViewController(viewController, sender: self)
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
