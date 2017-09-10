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
    
    func splitViewWith(primaryVC: UIViewController, secondaryVC: UIViewController) {
        if self.view.traitCollection.horizontalSizeClass == .regular {
            secondaryVC.navigationItem.leftBarButtonItem = self.displayModeButtonItem
        } else {
            
            let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            profileImageView.layer.cornerRadius = 15.0
            profileImageView.layer.masksToBounds = true
            
            if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
                profileImageView.downloadImageWithUrl(user.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
            }
            
            secondaryVC.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        }
        self.viewControllers = [primaryVC, secondaryVC]
    }
    
    func changePrimaryViewController(viewController: UIViewController) {
        self.show(viewController, sender: self)
    }
    
    func changeSecondaryViewController(viewController: UIViewController) {
        self.showDetailViewController(viewController, sender: self)
    }
    

}

extension UniversalAppSplitViewController: UISplitViewControllerDelegate {
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        if svc.displayMode == .primaryHidden || svc.displayMode == .primaryOverlay {
            return .allVisible
        }
        
        return .primaryHidden
    }
}
