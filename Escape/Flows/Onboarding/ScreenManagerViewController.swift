//
//  ScreenManagerViewController.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum StoryBoardIdentifier : String{
    case Onboarding = "Onboarding"
    case MainTab = "MainTab"
}

class ScreenManagerViewController: UIViewController {
    
    var currentStoryBoard : UIStoryboard?
    var currentPresentedViewController : UIViewController?
    var presentedViewControllers : [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreenVader.sharedVader.screenManagerVC = self
        UserDataProvider.sharedDataProvider.getSecurityToken()

        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        initialViewBootUp()
    }
    
    private func initialViewBootUp(){
    
        if (!ECUserDefaults.isLoggedIn()){ // if not login, open onBoardingflow
            
                openViewControllerWith(.Onboarding)
        
            
        }else{
                openViewControllerWith(.MainTab)
            
        }
        
    }
    
    private func openViewControllerWith(storyBoardIdentifier : StoryBoardIdentifier){
        
        currentPresentedViewController = initialViewControllerFor(storyBoardIdentifier)
        if let currentPresentedViewController = currentPresentedViewController{
            presentViewController(currentPresentedViewController, animated: false, completion: nil)
            if storyBoardIdentifier == .Onboarding{
                presentedViewControllers = []
            }

            presentedViewControllers.append(currentPresentedViewController)
        }
        
    }
    
    
    private func initialViewControllerFor(storyboardId: StoryBoardIdentifier) -> UIViewController {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()!
    }
    
    private func instantiateViewControllerWith(storyboard: StoryBoardIdentifier, forIdentifier: String) -> UIViewController {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewControllerWithIdentifier(forIdentifier)
    }
    

  

}

extension ScreenManagerViewController{
    
    func switchTabForAction(action : ScreenManagerAction){
        
        if let mainTAbVC = currentPresentedViewController as? MainTabBarViewController{
            switch action {
            case .HomeTab:
                mainTAbVC.selectedIndex = 0
                break
            case .DiscoverTab:
                mainTAbVC.selectedIndex = 1
                break
                
            case .MyAccountTab:
                mainTAbVC.selectedIndex = 2
                break
            default:
                mainTAbVC.selectedIndex = 0
                break
            }
        }
        
    }
    
    func performScreenManagerAction(action : ScreenManagerAction , params : [String:AnyObject]?){
        
        if currentPresentedViewController == nil{
            // do pending action here
            return
        }
        switch action{
            
        case .MainTab:
            openMainTab()
            break;
            
        default:
            break
        }
    }
    
    func openMainTab(){
        
        currentPresentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func performLogout(){
        currentPresentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        ECUserDefaults.setLoggedIn(false)
        
    }
    
}
