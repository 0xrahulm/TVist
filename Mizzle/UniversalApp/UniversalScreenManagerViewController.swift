//
//  UniversalScreenManagerViewController.swift
//  TVist
//
//  Created by Rahul Meena on 09/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import SafariServices

class UniversalScreenManagerViewController: UIViewController {
    
    var currentStoryBoard : UIStoryboard?
    var currentPresentedViewController : UIViewController!
    var currentPushedViewController : UIViewController!
    var presentedViewControllers : [UIViewController] = []
    
    
    var presentToast : UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPresentedViewController = self
        ScreenVader.sharedVader.universalScreenManagerVC = self
        
        
        presentedViewControllers.append(self)
        
        setNeedsStatusBarAppearanceUpdate()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initialViewBootUp()
    }
    
    fileprivate func initialViewBootUp() {
        if (ECUserDefaults.isLoggedIn()) {
            
            presentRootViewControllerOf(.UniversalApp, queryParams: nil)
        } else {
            
            UserDataProvider.sharedDataProvider.deviceSessionDelegate = self
            UserDataProvider.sharedDataProvider.getDeviceSession()
            
        }
    }
    
    
    fileprivate func presentRootViewControllerOf(_ storyBoardIdentifier : StoryBoardIdentifier, queryParams : [String:AnyObject]?){
        
        currentPresentedViewController = initialViewControllerFor(storyBoardIdentifier)
        
        
        if let currentPresentedViewController = currentPresentedViewController{
            
            if let queryParams = queryParams {
                currentPresentedViewController.setObjectsWithQueryParameters(queryParams)
            }
            
            if let currentPresentedViewController = currentPresentedViewController as? UniversalAppSplitViewController {
                setupUniversalSplitView(universalVC: currentPresentedViewController)
            }
            
            present(currentPresentedViewController, animated: false, completion: {
                if let pendingAction = ScreenVader.sharedVader.pendingUniversalScreenManagerAction, storyBoardIdentifier == .MainTab {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.initializedOnce = true
                    }
                    self.performScreenManagerAction(pendingAction, params: ScreenVader.sharedVader.pendingQueryParams)
                    ScreenVader.sharedVader.pendingUniversalScreenManagerAction = nil
                    ScreenVader.sharedVader.pendingQueryParams = nil
                }
            })
            
            if storyBoardIdentifier == .Onboarding{
                presentedViewControllers = []
            }
            
            presentedViewControllers.append(currentPresentedViewController)
        }
        
    }
    
    func setupUniversalSplitView(universalVC: UniversalAppSplitViewController) {
        universalVC.splitViewWith(primaryVC: primaryViewController(), secondaryVC: secondaryViewController())
    }
    
    func primaryViewController() -> UIViewController {
        return initialViewControllerFor(.User)!
    }
    
    func secondaryViewController() -> UIViewController {
        if let lastVisitedPage = LocalStorageVader.sharedVader.valueForStoredKey(.LastOpenScreen) as? String, let storedAction = UniversalScreenManagerAction(rawValue: lastVisitedPage), let mainViewToLoad = getMainViewForAction(action: storedAction) {
            return mainViewToLoad
        }
        
        return getMainViewForAction(action: .TodayMasterView)!
    }
    
    func getMainViewForAction(action: UniversalScreenManagerAction) -> UIViewController? {
        var storyboardIdentifier = StoryBoardIdentifier.Master
        
        if action == .WatchlistMasterView {
            storyboardIdentifier = .Watchlist
        }
        
        return initialViewControllerFor(storyboardIdentifier)
    }
    
    fileprivate func initialViewControllerFor(_ storyboardId: StoryBoardIdentifier) -> UIViewController? {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
    fileprivate func instantiateViewControllerWith(_ storyboard: StoryBoardIdentifier, forIdentifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: forIdentifier)
    }
    
    func performScreenManagerAction(_ action: UniversalScreenManagerAction, params: [String:Any]?) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UniversalScreenManagerViewController: DeviceSessionProtocol {
    func guestUserLoggedIn() {
        initialViewBootUp()
        AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceSessionGenerated)
    }
    
    func userAlreadyExists(registeredUsers: [MyAccountItems]) {
        presentRootViewControllerOf(.Onboarding, queryParams: nil)
    }
}
