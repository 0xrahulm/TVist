//
//  CustomNavigationViewController.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController, UINavigationControllerDelegate {

    let customNavigationAnimationController = CustomNavigationAnimationController()
    let customInteractionController = CustomInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setAppearnce()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func setAppearnce(){
        
        self.navigationBar.barTintColor = UIColor.escapeGray()
        self.navigationBar.tintColor = UIColor.themeColorBlack()
        self.navigationBar.translucent = false
        self.navigationBar.titleTextAttributes = SFUIAttributedText.regularAttributesForSize(17.0, color: UIColor.themeColorBlack())
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        super.dismissViewControllerAnimated(flag, completion: completion)
        if isBeingDismissed() {
            ScreenVader.sharedVader.removeDismissedViewController(self)
    
        }
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            customInteractionController.attachToViewController(toVC)
        }
        
        customNavigationAnimationController.reverse = operation == .Pop
        return customNavigationAnimationController
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }

}
