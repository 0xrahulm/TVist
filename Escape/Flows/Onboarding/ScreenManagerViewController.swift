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
    
    var noNetworkVC = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPresentedViewController = self
        ScreenVader.sharedVader.screenManagerVC = self
        UserDataProvider.sharedDataProvider.getSecurityToken()
        
        presentedViewControllers.append(self)
        
        setNeedsStatusBarAppearanceUpdate()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initialViewBootUp()
    }
    
    fileprivate func initialViewBootUp() {
        if (ECUserDefaults.isLoggedIn() &&
            LocalStorageVader.sharedVader.flagValueForKey(.InterestsSelected)) {
            
            // Get user details early on so the data is available before 
            MyAccountDataProvider.sharedDataProvider.getUserDetails(nil)
            
            presentRootViewControllerOf(.MainTab, queryParams: nil)
        } else {
            presentRootViewControllerOf(.Onboarding, queryParams: nil)
        }
    }
    
    fileprivate func presentRootViewControllerOf(_ storyBoardIdentifier : StoryBoardIdentifier, queryParams : [String:AnyObject]?){
        
        currentPresentedViewController = initialViewControllerFor(storyBoardIdentifier)
        
        if let currentPresentedViewController = currentPresentedViewController{
            
            if let queryParams = queryParams{
                
                currentPresentedViewController.setObjectsWithQueryParameters(queryParams)
                
            }
            
            present(currentPresentedViewController, animated: false, completion: {
                if let pendingAction = ScreenVader.sharedVader.pendingScreenManagerAction, storyBoardIdentifier == .MainTab {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.initializedOnce = true
                    }
                    self.performScreenManagerAction(pendingAction, params: ScreenVader.sharedVader.pendingQueryParams)
                    ScreenVader.sharedVader.pendingScreenManagerAction = nil
                    ScreenVader.sharedVader.pendingQueryParams = nil
                }
            })
            
            if storyBoardIdentifier == .Onboarding{
                presentedViewControllers = []
            }
            
            presentedViewControllers.append(currentPresentedViewController)
        }
        
    }
    fileprivate func pushInitialViewControllerOf(_ storyBoardIdentifier : StoryBoardIdentifier , queryParams : [String:AnyObject]?){
        
        if currentPresentedViewController != nil{
            if currentPresentedViewController is MainTabBarViewController {
                let mainTabVC = currentPresentedViewController as! MainTabBarViewController
                if let customNavVC = mainTabVC.getSelectedTabViewController() as? CustomNavigationViewController{
                    
                    self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                    if let vc = initialViewControllerFor(storyBoardIdentifier){
                        if let params = queryParams{
                            vc.setObjectsWithQueryParameters(params)
                        }
                        customNavVC.pushViewController(vc, animated : true)
                    }
                    
                }
            }else if let currentNavVc = currentPresentedViewController as? CustomNavigationViewController{
                self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                
                if let vc = initialViewControllerFor(storyBoardIdentifier){
                    if let params = queryParams{
                        vc.setObjectsWithQueryParameters(params)
                    }
                    currentNavVc.pushViewController(vc, animated : true)
                }
            }
        }
    }
    
    
    fileprivate func pushViewControllerOf(_ storyBoardIdentifier : StoryBoardIdentifier,viewControllerIdentifier : String , queryParams : [String:Any]?){
        
        if currentPresentedViewController != nil{
            if currentPresentedViewController is MainTabBarViewController {
                let mainTabVC = currentPresentedViewController as! MainTabBarViewController
                if let customNavVC = mainTabVC.getSelectedTabViewController() as? CustomNavigationViewController{
                    
                    self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                    
                    customNavVC.pushViewController(getViewControllerToOpen(storyBoardIdentifier, forIdentifier: viewControllerIdentifier, queryParam: queryParams), animated: true)
                    
                }
            }else if let currentNavVc = currentPresentedViewController as? CustomNavigationViewController{
                self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                
                currentNavVc.pushViewController(getViewControllerToOpen(storyBoardIdentifier, forIdentifier: viewControllerIdentifier, queryParam: queryParams), animated: true)
                
            }
        }
        
    }
    
    fileprivate func presentViewControllerOf(_ storyBoardIdentifier : StoryBoardIdentifier,viewControllerIdentifier : String , queryParams : [String:Any]?){
        
        
        if let presentingVC = instantiateViewControllerWith(storyBoardIdentifier, forIdentifier: viewControllerIdentifier){
            
            if let queryParams = queryParams{
                if let vc = presentingVC as? CustomNavigationViewController{
                    vc.viewControllers[0].setObjectsWithQueryParameters(queryParams)
                }
                
            }
            currentPresentedViewController.present(presentingVC, animated: true, completion: nil)
            currentPresentedViewController = presentingVC
            presentedViewControllers.append(presentingVC)
            
        }
    }
    
    fileprivate func presentPopUpViewWithNib( _ viewController : UIViewController){
        
        currentPresentedViewController.present(viewController, animated: true, completion: nil)
        currentPresentedViewController = viewController
        presentedViewControllers.append(viewController)
        
        
    }
    
    fileprivate func initialViewControllerFor(_ storyboardId: StoryBoardIdentifier) -> UIViewController? {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
    fileprivate func instantiateViewControllerWith(_ storyboard: StoryBoardIdentifier, forIdentifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: forIdentifier)
    }
    
    fileprivate func getViewControllerToOpen(_ storyboard: StoryBoardIdentifier, forIdentifier: String?, queryParam: [String:Any]?) -> UIViewController {
        
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
    
    func getTopViewController() -> UIViewController {
        if currentPresentedViewController != nil {
            if let mainTabVC  = currentPresentedViewController as? MainTabBarViewController {
                if let selectedNav = mainTabVC.getSelectedTabViewController() as? CustomNavigationViewController {
                    return selectedNav.topViewController!
                }
            }
            
            if let selectedNav = currentPresentedViewController as? CustomNavigationViewController {
                return selectedNav.topViewController!
            }
        }
        
        return self
    }
    
    func hideTabBar(_ hide: Bool) {
        if let mainTabVC = currentPresentedViewController as? MainTabBarViewController {
            mainTabVC.tabBar.isHidden = hide
        }
    }
    
    func showAlert(alert: UIAlertController) {
        currentPresentedViewController.present(alert, animated: true, completion: nil)
    }
    
    func changeStatusBarPreference(_ shouldBeBlack: Bool) {
        if let mainTabVC = currentPresentedViewController as? MainTabBarViewController {
            mainTabVC.shouldBeBlack = shouldBeBlack
        }
    }
    
    func removePresentedViewController(_ dismissVC : UIViewController){
        
        if currentPresentedViewController == dismissVC {
            if presentedViewControllers.count > 0 {
                
                presentedViewControllers.remove(at: presentedViewControllers.count-1)
                
                if presentedViewControllers.count > 0 {
                    
                    currentPresentedViewController = presentedViewControllers[presentedViewControllers.count-1]
                }
                
            }
        }
    }
}

extension ScreenManagerViewController{
    
    func switchTabForAction(_ action : ScreenManagerAction){
        
        if let mainTAbVC = currentPresentedViewController as? MainTabBarViewController {
            switch action {
            case .HomeTab:
                mainTAbVC.selectedIndex = MainTabIndex.Guide.index
                break
            case .DiscoverTab:
                mainTAbVC.selectedIndex = MainTabIndex.Guide.index
                break
                
            case .MyAccountTab:
                mainTAbVC.selectedIndex = MainTabIndex.Guide.index
                break
            default:
                mainTAbVC.selectedIndex = MainTabIndex.Guide.index
                break
            }
        }
        
    }
    
    func performScreenManagerAction(_ action : ScreenManagerAction , params : [String:Any]?){
        
        if currentPresentedViewController == nil{
            // do pending action here
            return
        }
        switch action{
        case .MainTab:
            openMainTab()
            break
            
        case .DiscoverTab:
            fallthrough
        case .SearchTab:
            fallthrough
        case .MyAccountTab:
            switchTabForAction(action)
            break
        case .MyAccountSetting:
            openMyAccountSetting(params)
            break
            
        case .OpenItemDescription:
            openItemDesc(params)
            break
            
        case .OpenFollowers:
            openFollower(params)
            break
            
        case .OpenAddToEscapePopUp:
            openAddToEscapePopUp(params)
            break
            
            
        case .OpenEditEscapePopUp:
            openEditEscapePopup(params)
            break
            
        case .OpenUserAccount:
            openUserAccount(params)
            break
            
        case .NoNetworkPresent:
            presentNoNetworkPopUP()
            break
            
        case .NetworkPresent:
            noNetworkCloseTapped()
            break
            
        case .OpenSearchView:
            openSearchView(params)
            break
            
        case .OpenUserEscapesList:
            if let params = params {
                openUserEscapeListViewController(params)
            }
            break
            
        case .OpenFriendsView:
            openFriendsView(params)
            break
            
        case .OpenSingleStoryView:
            openSingleStory(params)
            break
            
        case .OpenSimilarEscapesView:
            openSimilarEscapesView(params)
            break
        case .OpenRelatedPeopleView:
            openRelatedPeopleView(params)
            break
        case .OpenNotificationView:
            openNotificationVC()
            break
        default:
            break
        }
    }
    
    func openMainTab(){
        
        currentPresentedViewController?.dismiss(animated: true, completion: nil)
        
    }
    func performLogout(){
        currentPresentedViewController?.dismiss(animated: true, completion: nil)
        ECUserDefaults.setLoggedIn(false)
        
    }
    func openMyAccountSetting(_ params : [String:Any]?){
        pushViewControllerOf(.MyAccount, viewControllerIdentifier: "myAccountSettingVC", queryParams: params)
    }
    func openItemDesc(_ params : [String:Any]?){
        var escapeType = ""
        if let params = params {
            
            if let escapeItem = params["escapeItem"] as? EscapeItem {
                escapeType = escapeItem.escapeType
            }
            
            if let escapeTypeVal = params["escape_type"] as? String {
                escapeType = escapeTypeVal
            }
        }
        if escapeType == EscapeType.Books.rawValue {
            
            pushViewControllerOf(.MyAccount, viewControllerIdentifier: "itemDescVC", queryParams: params)
        } else {
            pushViewControllerOf(.TvGuide, viewControllerIdentifier: "itemDescVC", queryParams: params)
        }
    }
    func openFollower(_ params : [String:Any]?){
        pushViewControllerOf(.MyAccount, viewControllerIdentifier: "FollowersVC", queryParams: params)
    }
    
    func openUserEscapeListViewController(_ params: [String:Any]) {
        pushViewControllerOf(.GenericLists, viewControllerIdentifier: "userEscapeListVC", queryParams: params)
    }
    
    func openAddToEscapePopUp(_ params : [String:Any]?){
        
        if let params = params{
            
            let addToEscapePopup = AddToEscapeViewController(nibName:"AddToEscapeViewController", bundle: nil)
            addToEscapePopup.modalPresentationStyle = .custom
            addToEscapePopup.transitioningDelegate = addToEscapePopup
            addToEscapePopup.presentingVC = self
            addToEscapePopup.queryParams = params
            
            presentPopUpViewWithNib(addToEscapePopup)
            
        }
    }
    
    func openEditEscapePopup(_ params: [String:Any]?) {
        guard let params = params else {
            return
        }
        
        let editEscapePopup = EditEscapeViewController(nibName: "EditEscapeViewController", bundle: nil)
        editEscapePopup.modalPresentationStyle = .custom
        editEscapePopup.transitioningDelegate = editEscapePopup
        editEscapePopup.presentingVC = self
        editEscapePopup.queryParams = params
        
        presentPopUpViewWithNib(editEscapePopup)
        
    }
    
    func openUserAccount(_ params : [String:Any]?){
        pushViewControllerOf(.MyAccount, viewControllerIdentifier: "myAccountVC", queryParams: params)        
    }
    func openFriendsView(_ params : [String:Any]?){
        pushViewControllerOf(.MyAccount, viewControllerIdentifier: "friendsVC", queryParams: params)
        
    }
    
    func openSimilarEscapesView(_ params: [String:Any]?) {
        pushViewControllerOf(.GenericLists, viewControllerIdentifier: "similarEscapesVC", queryParams: params)
    }
    
    func openRelatedPeopleView(_ params: [String:Any]?) {
        pushViewControllerOf(.GenericLists, viewControllerIdentifier: "RelatedPeopleVC", queryParams: params)
    }
    
    func openSingleStory(_ params : [String:Any]?){
         pushViewControllerOf(.Home, viewControllerIdentifier: "singleStoryVC", queryParams: params)
    }
    func openNotificationVC(){
        pushViewControllerOf(.Notifications, viewControllerIdentifier: "notificationVC", queryParams: nil)
    }
    func presentNoNetworkPopUP(){
        
        noNetworkVC = NoNetworkView(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.width, height: 30))
        
        getTopViewController().view.addSubview(noNetworkVC)
        
        UIView.transition(with: noNetworkVC, duration:0.5,options:.transitionCrossDissolve,
                                  animations:
            { () -> Void in
                self.noNetworkVC.frame.origin.y = 0
            },
            completion: nil);
    }
    
    func noNetworkCloseTapped(){
        
        UIView.transition(with: noNetworkVC,duration:0.5,options:.transitionCrossDissolve,
                                  animations:
            { () -> Void in
                self.noNetworkVC.frame.origin.y = -64
                
            },
                completion: { (finished) -> Void in
                //self.noNetworkVC.hidden = true
        });
    }
    
    func openSearchView(_ params : [String:Any]?){
        presentViewControllerOf(.Search, viewControllerIdentifier: "searchVC", queryParams: params)
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

