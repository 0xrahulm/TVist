//
//  CustomNavigationViewController.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit


let kDefaultIconSize:CGFloat = 30

class CustomNavigationViewController: UINavigationController, UINavigationControllerDelegate {
    
    var presentingVC: UIViewController?
    var presentedVCObj : CustomPopupPresentationController?
    
    let customNavigationAnimationController = CustomNavigationAnimationController()
    let customInteractionController = CustomInteractionController()
    
    var popupHeight: CGFloat = 480
    var popupWidth: CGFloat = 316
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setAppearnce()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tabViewSetupWithTitle(title: String) {
        var normalImage:String = ion_ios_book_outline
        var selectedImage:String = ion_ios_book
        
        if title == "Guide" {
            // nothing to do
        } else if title == "Search" {
            selectedImage = ion_ios_search
            normalImage = ion_ios_search
        } else if title == "Remote" {
            selectedImage = ion_ios_monitor
            normalImage = ion_ios_monitor_outline
        } else if title == "Tracker" {
            selectedImage = ion_ios_timer_outline
            normalImage = ion_ios_timer_outline
        } else if title == "Watchlist" {
            selectedImage = ion_navicon
            normalImage = ion_navicon
        } else if title == "Home" {
            selectedImage = ion_ios_home
            normalImage = ion_ios_home_outline
        }
        
        tabBarItem.image = IonIcons.image(withIcon: normalImage, size: kDefaultIconSize, color: UIColor.buttonGrayColor())
        tabBarItem.selectedImage = IonIcons.image(withIcon: selectedImage, size: kDefaultIconSize, color: UIColor.defaultTintColor())
        
        tabBarItem.setTitleTextAttributes(SFUIAttributedText.regularAttributesForSize(12, color: UIColor.buttonGrayColor()), for: .normal)
        tabBarItem.setTitleTextAttributes(SFUIAttributedText.regularAttributesForSize(12, color: UIColor.defaultTintColor()), for: .selected)
        
    }
   
    func setAppearnce(){
        
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.defaultCTAColor()
        
        self.navigationBar.titleTextAttributes = SFUIAttributedText.regularAttributesForSize(17.0, color: UIColor.styleGuideMainTextColor())
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        super.dismiss(animated: flag, completion: completion)
        if isBeingDismissed {
            ScreenVader.sharedVader.removeDismissedViewController(self)
        }
        
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            customInteractionController.attachToViewController(toVC)
        }
        
        customNavigationAnimationController.reverse = operation == .pop
        return customNavigationAnimationController
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }

}


extension CustomNavigationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CustomNavigationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if let presentingVC = self.presentingVC {
            let presntingWidth = presentingVC.view.bounds.width*0.60
            if presntingWidth > popupWidth {
                popupWidth = presntingWidth
            }
            let presetingHeight = presentingVC.view.bounds.height*0.70
            if presetingHeight > popupHeight {
                popupHeight = presetingHeight
            }
        }
        let presentationController = CustomPopupPresentationController(presentedViewController: presented, presentingViewController: presentingVC!, width: popupWidth, height: popupHeight, yOffset: 0, cornerRadius: 4)
        presentedVCObj = presentationController
        return presentationController;
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: false)
    }
}
