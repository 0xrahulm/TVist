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

    let customNavigationAnimationController = CustomNavigationAnimationController()
    let customInteractionController = CustomInteractionController()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let title = self.title {
            tabViewSetupWithTitle(title: title)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setAppearnce()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tabViewSetupWithTitle(title: String) {
        var normalImage:String = ion_ios_paper_outline
        var selectedImage:String = ion_ios_paper
        
        if title == "Guide" {
            // nothing to do
        } else if title == "Search" {
            selectedImage = ion_ios_search
            normalImage = ion_ios_search
        } else if title == "Top Charts" {
            selectedImage = ion_ios_list
            normalImage = ion_ios_list_outline
        } else if title == "Tracker" {
            selectedImage = ion_ios_timer_outline
            normalImage = ion_ios_timer_outline
        } else if title == "Watchlist" {
            selectedImage = ion_navicon
            normalImage = ion_navicon
        }
        
        tabBarItem.image = IonIcons.image(withIcon: normalImage, size: kDefaultIconSize, color: UIColor.buttonGrayColor())
        tabBarItem.selectedImage = IonIcons.image(withIcon: selectedImage, size: kDefaultIconSize, color: UIColor.defaultTintColor())
        
        tabBarItem.setTitleTextAttributes(SFUIAttributedText.regularAttributesForSize(12, color: UIColor.buttonGrayColor()), for: .normal)
        tabBarItem.setTitleTextAttributes(SFUIAttributedText.regularAttributesForSize(12, color: UIColor.defaultTintColor()), for: .selected)
        
    }
   
    func setAppearnce(){
        
        self.navigationBar.barTintColor = UIColor.escapeGray()
        self.navigationBar.tintColor = UIColor.defaultCTAColor()
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.titleTextAttributes = SFUIAttributedText.regularAttributesForSize(17.0, color: UIColor.themeColorBlack())
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
