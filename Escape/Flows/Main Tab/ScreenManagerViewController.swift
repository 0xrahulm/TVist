//
//  ScreenManagerViewController.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class ScreenManagerViewController: UIViewController {
    
    var currentStoryBoard : UIStoryboard?
    var currentPresentedViewController : UIViewController!
    var currentPushedViewController : UIViewController!
    var presentedViewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPresentedViewController = self
        ScreenVader.sharedVader.screenManagerVC = self
        UserDataProvider.sharedDataProvider.getSecurityToken()
        
        presentedViewControllers.append(self)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        initialViewBootUp()
    }
    
    private func initialViewBootUp(){
        
        if (!ECUserDefaults.isLoggedIn()){ // if not login, open onBoardingflow
            
            presentRootViewControllerOf(.Onboarding , queryParams: nil)
            
        }else{
            
            presentRootViewControllerOf(.MainTab , queryParams: nil)
          
        }
        
    }
    
    private func pushInitialViewControllerOf(storyBoardIdentifier : StoryBoardIdentifier , queryParams : [String:AnyObject]?){
        
        if let currentPresentedViewController = currentPresentedViewController as? CustomNavigationViewController {
            
            if let currentPushedVC = initialViewControllerFor(storyBoardIdentifier){
                
                if let queryParams = queryParams{
                    currentPushedVC.setObjectsWithQueryParameters(queryParams)
                }
                 self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                
                currentPresentedViewController.pushViewController(currentPushedVC, animated: true)
                currentPushedViewController = currentPushedVC
            }
        }
    }
    
    private func presentRootViewControllerOf(storyBoardIdentifier : StoryBoardIdentifier, queryParams : [String:AnyObject]?){
        
        currentPresentedViewController = initialViewControllerFor(storyBoardIdentifier)
        if let currentPresentedViewController = currentPresentedViewController{
            
            if let queryParams = queryParams{
                
                currentPresentedViewController.setObjectsWithQueryParameters(queryParams)
                
            }
            
            presentViewController(currentPresentedViewController, animated: false, completion: nil)
            
            if storyBoardIdentifier == .Onboarding{
                presentedViewControllers = []
            }
            
            presentedViewControllers.append(currentPresentedViewController)
        }
        
    }
    
    private func pushViewControllerOf(storyBoardIdentifier : StoryBoardIdentifier,viewControllerIdentifier : String , queryParams : [String:AnyObject]?){
        
        if currentPresentedViewController != nil{
            if currentPresentedViewController is MainTabBarViewController{
                let mainTabVC = currentPresentedViewController as! MainTabBarViewController
                if let customNavVC = mainTabVC.selectedViewController as? CustomNavigationViewController{
                    
                    self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                    
                    customNavVC.pushViewController(getViewControllerToOpen(storyBoardIdentifier, forIdentifier: viewControllerIdentifier, queryParam: queryParams), animated: true)
                    
                }
            }else if let currentNavVc = currentPresentedViewController as? CustomNavigationViewController{
                 self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                
                currentNavVc.pushViewController(getViewControllerToOpen(storyBoardIdentifier, forIdentifier: viewControllerIdentifier, queryParam: queryParams), animated: true)
                
            }
        }
      
    }
    
    private func presentViewControllerOf(storyBoardIdentifier : StoryBoardIdentifier,viewControllerIdentifier : String , queryParams : [String:AnyObject]?){
        
        
        if let presentingVC = instantiateViewControllerWith(storyBoardIdentifier, forIdentifier: viewControllerIdentifier){
            
            if let queryParams = queryParams{
                presentingVC.setObjectsWithQueryParameters(queryParams)
            }
            currentPresentedViewController.presentViewController(presentingVC, animated: true, completion: nil)
            currentPresentedViewController = presentingVC
            presentedViewControllers.append(presentingVC)
            
        }
    }
    
    private func initialViewControllerFor(storyboardId: StoryBoardIdentifier) -> UIViewController? {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
    private func instantiateViewControllerWith(storyboard: StoryBoardIdentifier, forIdentifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewControllerWithIdentifier(forIdentifier)
    }
    
    private func getViewControllerToOpen(storyboard: StoryBoardIdentifier, forIdentifier: String?, queryParam: [String:AnyObject]?) -> UIViewController {
        
        var viewControllerToOpen: UIViewController!
        if let forIdentifier = forIdentifier {
            viewControllerToOpen = instantiateViewControllerWith(storyboard, forIdentifier: forIdentifier)
        } else {
            viewControllerToOpen = initialViewControllerFor(storyboard)
        }
        
        if let queryParam = queryParam {
            viewControllerToOpen.setObjectsWithQueryParameters(queryParam)
        }
        return viewControllerToOpen
    }
    
    func removePresentedViewController(dismissVC : UIViewController){
        
        if currentPresentedViewController == dismissVC {
            
            presentedViewControllers.removeAtIndex(0)
            
            if presentedViewControllers.count > 0 {
                currentPresentedViewController = presentedViewControllers[0]
            }
        }
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
            break
            
        case .MyAccountSetting:
            openMyAccountSetting()
            break
            
        case .OpenItemDescription:
            openItemDesc(params)
            break
            
        case .OpenFollowers:
            openFollower(params)
            break
            
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
    func openMyAccountSetting(){
        pushViewControllerOf(.MyAccount, viewControllerIdentifier: "myAccountSettingVC", queryParams: nil)
    }
    func openItemDesc(params : [String:AnyObject]?){
        pushViewControllerOf(.MyAccount, viewControllerIdentifier: "itemDescVC", queryParams: params)
    }
    func openFollower(params : [String:AnyObject]?){
        pushViewControllerOf(.MyAccount, viewControllerIdentifier: "FollowersVC", queryParams: params)
    }
    
}
