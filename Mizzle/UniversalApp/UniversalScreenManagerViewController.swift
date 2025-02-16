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
    
    var isLoadedOnce:Bool = false
    
    var currentStoryBoard : UIStoryboard?
    var currentPresentedViewController : UIViewController!
    var currentPushedViewController : UIViewController!
    var presentedViewControllers : [UIViewController] = []
    
    var presentToast : UIWindow?
    
    var detailViewReference: [UniversalScreenManagerAction: UIViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPresentedViewController = self
        ScreenVader.sharedVader.universalScreenManagerVC = self
        
        
        presentedViewControllers.append(self)
        
        setNeedsStatusBarAppearanceUpdate()

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isLoadedOnce {
            rebootView()
            isLoadedOnce = true
        }
        
    }
    
    @objc func rebootView() {
        if self.currentPresentedViewController == self {
            initialViewBootUp()
        }
    }
    
    fileprivate func initialViewBootUp() {
        if (ECUserDefaults.isLoggedIn()) {
            
            presentRootViewControllerOf(.UniversalApp, asPopover: false, queryParams: nil)
        } else {
            
            UserDataProvider.sharedDataProvider.deviceSessionDelegate = self
            UserDataProvider.sharedDataProvider.getDeviceSession()
            
        }
    }
    
    
    fileprivate func presentRootViewControllerOf(_ storyBoardIdentifier: StoryBoardIdentifier, asPopover: Bool, queryParams: [String:AnyObject]?) {
        if let currentPresentedViewController = initialViewControllerFor(storyBoardIdentifier) {
            
            presentViewController(presentingVC: currentPresentedViewController, asPopover: asPopover, queryParams: queryParams)
        }
    }
    
    
    fileprivate func presentViewController(presentingVC: UIViewController, asPopover: Bool, queryParams: [String: Any]?) {
        
        if let queryParams = queryParams {
            if let presentingVC = presentingVC as? CustomNavigationViewController {
                if let addDoneButton = queryParams["addDoneButton"] as? Bool, addDoneButton {
                    presentingVC.viewControllers[0].addNavigationBarDoneButton()
                }
                presentingVC.viewControllers[0].setObjectsWithQueryParameters(queryParams)
            } else {
                presentingVC.setObjectsWithQueryParameters(queryParams)
            }
        }
        
        if let currentPresentedViewController = presentingVC as? UniversalAppSplitViewController {
            setupUniversalSplitView(universalVC: currentPresentedViewController)
        }
        
        if asPopover {
            presentingVC.modalPresentationStyle = .popover
            if let presentationController = presentingVC.popoverPresentationController {
                if let sourceView = self.currentPresentedViewController.view {

                    var popupWidth:CGFloat = 320
                    var popupHeight:CGFloat = 400
                    
                    if sourceView.bounds.width*0.60 > popupWidth {
                        popupWidth = sourceView.bounds.width*0.60
                    }
                    
                    if sourceView.bounds.height*0.70 > popupHeight {
                        popupHeight = sourceView.bounds.height*0.70
                    }
                    presentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                    presentationController.sourceView = sourceView
                    presentationController.passthroughViews = nil
                    
                    presentationController.sourceRect = CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 0, height: 0)
                    presentingVC.isModalInPopover = true
                    presentingVC.preferredContentSize = CGSize(width: popupWidth, height: popupHeight)
                }
            }
        }
        
        self.currentPresentedViewController.present(presentingVC, animated: asPopover) {
            
            if let pendingAction = ScreenVader.sharedVader.pendingUniversalScreenManagerAction {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.initializedOnce = true
                }
                self.performScreenManagerAction(pendingAction, params: ScreenVader.sharedVader.pendingQueryParams)
                
                ScreenVader.sharedVader.pendingUniversalScreenManagerAction = nil
                ScreenVader.sharedVader.pendingQueryParams = nil
            }
            
            self.currentPresentedViewController = presentingVC
            self.presentedViewControllers.append(presentingVC)
        }
        
    }
    
    fileprivate func presentViewControllerOf(_ storyBoardIdentifier: StoryBoardIdentifier, viewControllerIdentifier: String, asPopover: Bool, queryParams: [String:Any]?) {
        if let presentingVC = instantiateViewControllerWith(storyBoardIdentifier, forIdentifier: viewControllerIdentifier) {
            presentViewController(presentingVC: presentingVC, asPopover: asPopover, queryParams: queryParams)
        }
    }
    
    func setupUniversalSplitView(universalVC: UniversalAppSplitViewController) {
        universalVC.isRegular = self.view.traitCollection.horizontalSizeClass == .regular
        universalVC.splitViewWith(primaryVC: primaryViewController(), secondaryVC: secondaryViewController())
    }
    
    func primaryViewController() -> UIViewController {
        return initialViewControllerFor(.User)!
    }
    
    func secondaryViewController() -> UIViewController {
        
        if let lastVisitedPage = LocalStorageVader.sharedVader.valueForStoredKey(.LastOpenScreen) as? String, let storedAction = UniversalScreenManagerAction(rawValue: lastVisitedPage), let mainViewToLoad = getMainViewForAction(action: storedAction) {
            return mainViewToLoad
        }
        
        return getMainViewForAction(action: .todayDetailView)!
    }
    
    func getMainViewForAction(action: UniversalScreenManagerAction) -> UIViewController? {
        var storyboardIdentifier = StoryBoardIdentifier.Home
        
        if action == .watchlistDetailView || action == .seenDetailView {
            storyboardIdentifier = .Watchlist
        } else if action == .airingNowDetailView {
            storyboardIdentifier = .WhatsOn
        } else if action == .openSearchView {
            storyboardIdentifier = .Search
        }
        
        let initialVC = initialViewControllerFor(storyboardIdentifier)
        var queryParams: [String: Any]?
        
        if action == .seenDetailView {
            queryParams = ["showSeen": true]
        } else if action == .discoverDetailView {
            queryParams = ["viewType": HomeViewType.discover]
        } else if action == .next7DaysDetailView {
            queryParams = ["viewType": HomeViewType.next7Days]
        } else if action == .todayDetailView {
            queryParams = ["viewType": HomeViewType.today]
        }
        
        if let queryParams = queryParams {
         
            if let initialNav = initialVC as? CustomNavigationViewController {
                let rootVC = initialNav.viewControllers[0]
                rootVC.setObjectsWithQueryParameters(queryParams)
            }
            
            if let detailVC = initialVC as? GenericDetailViewController {
                detailVC.setObjectsWithQueryParameters(queryParams)
            }
        }
        return initialVC
    }
    
    fileprivate func initialViewControllerFor(_ storyboardId: StoryBoardIdentifier) -> UIViewController? {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
    fileprivate func instantiateViewControllerWith(_ storyboard: StoryBoardIdentifier, forIdentifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: forIdentifier)
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
    
    func performScreenManagerAction(_ action: UniversalScreenManagerAction, params: [String:Any]?) {
        switch action {
        case .discoverDetailView:
            fallthrough
        case .watchlistDetailView:
            fallthrough
        case .seenDetailView:
            fallthrough
        case .todayDetailView:
            fallthrough
        case .next7DaysDetailView:
            fallthrough
        case .openSearchView:
            fallthrough
        case .airingNowDetailView:
            LocalStorageVader.sharedVader.storeValueInKey(.LastOpenScreen, value: action.rawValue)
            
            switchDetailViewWithAction(action: action, params: params)
            break
        case .openUserView:
            openUserView()
            break
        case .openSignUpView:
            openSignUpView()
            break
        case .openUserSettingsView:
            openUserSettingsView()
            break
        case .openTVistPremiumView:
            openTVistPremiumView()
            break
        case .restorePurchasesView:
            restorePurchases()
            break
        case .openMediaItemDescriptionView:
            openItemDesc(params)
            break
        case .openAlertOptionsView:
            openAlertOptionsView()
            break
        case .openProfileEditView:
            openProfileEditView()
            break
        case .openPremiumPopupView:
            openPremiumPopupView(params)
            break
        case .openTimeZoneSelectionView:
            openTimeZoneSelectionView()
            break
        case .openAddToWatchlistView:
            openAddToWatchlistPopUp(params)
            break
        case .openHelpAndSupportView:
            openHelpAndSupportView()
            break
        case .openHomeDiscoverItemView:
            openHomeDiscoverItemView(params: params)
            break
        case .openChannelListingView:
            openChannelListingView(params: params)
            break
        case .openBrowseByGenreView:
            if let params = params {
                openBrowseByGenreView(params: params)
            }
            break
            
        case .openAllGenreView:
            openAllGenreView()
            break
        case .openAllAirtimesView:
            if let params = params {
                openAllAirtimesView(params)
            }
            break
        case .openUpdateDetailsInputView:
            openUpdateDetailsView(params)
            break
        case .openLoginView:
            openLoginView()
            break
        case .logOutUser:
            MyAccountDataProvider.sharedDataProvider.logoutUser()
            
            dismissAllPresented()
            break
        case .openSimilarEscapesView:
            openSimilarEscapesView(params)
            break
        default:
            break
        }
    }
    
    func restorePurchases() {
        IAPVader.sharedVader.restorePuchases()
    }
    
    func openSearchView(queryParams: [String:Any]?) {
        
        openMasterPopup(storyboardIdentifier: .Search, vcIdentifier: "searchVC", navIdentifier: "searchNav")
    }
    
    
    func openChannelListingView(params: [String: Any]?) {
        
        if let _ = getTopViewController() as? ChannelListingViewController {
            return
        }
        pushViewControllerOf(storyboard: .Listings, forIdentifier: "channelListingView", queryParams: params)
    }
    
    func openAllGenreView() {
        pushViewControllerOf(storyboard: .Home, forIdentifier: "allGenreView", queryParams: nil)
    }
    
    func openBrowseByGenreView(params: [String:Any]?) {
        if let _ = getTopViewController() as? BrowseByGenreViewController {
            return
        }
        pushViewControllerOf(storyboard: .Home, forIdentifier: "browseByGenre", queryParams: params)
    }
    
    func openHomeDiscoverItemView(params: [String:Any]?) {
        pushViewControllerOf(storyboard: .Home, forIdentifier: "homeItemView", queryParams: params)
    }
    
    func openSimilarEscapesView(_ params: [String:Any]?) {
        pushViewControllerOf(storyboard: .GenericLists, forIdentifier: "similarEscapesVC", queryParams: params)
    }
    
    func openItemDesc(_ params: [String:Any]?) {
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
            pushViewControllerOf(storyboard: .MyAccount, forIdentifier: "itemDescVC", queryParams: params)
        } else {
            pushViewControllerOf(storyboard: .TvGuide, forIdentifier: "itemDescVC", queryParams: params)
        }
    }
    
    func openAllAirtimesView(_ params: [String:Any]) {
        pushViewControllerOf(storyboard: .TvGuide, forIdentifier: "allAirtimesVC", queryParams: params)
    }
    
    func openPremiumPopupView(_ params:[String:Any]?) {
        let premiumPopupView = UpgradeNowPopupViewController(nibName: "UpgradeNowPopupViewController", bundle: nil)
        
        premiumPopupView.modalPresentationStyle = .custom
        premiumPopupView.transitioningDelegate = premiumPopupView
        
        premiumPopupView.presentingVC = self
        if let params = params {
            premiumPopupView.setObjectsWithQueryParameters(params)
        }
        
        currentPresentedViewController.present(premiumPopupView, animated: true, completion: nil)
        
    }
    
    
    
    func openUpdateDetailsView(_ params:[String:Any]?) {
        if let params = params {
            
            let updateDetailsView = UpdateDetailsInputViewController(nibName: "UpdateDetailsInputViewController", bundle: nil)
            
            updateDetailsView.modalPresentationStyle = .custom
            updateDetailsView.transitioningDelegate = updateDetailsView
            
            updateDetailsView.presentingVC = self
            
            updateDetailsView.setObjectsWithQueryParameters(params)
            currentPresentedViewController.present(updateDetailsView, animated: true, completion: nil)
            
            
        }
    }
    
    func openAddToWatchlistPopUp(_ params: [String:Any]?) {
        
        if let params = params{
            
            if let addToWatchlistPopup = instantiateViewControllerWith(.Watchlist, forIdentifier: "addToWatchlistNav") as? CustomNavigationViewController {
                
                addToWatchlistPopup.modalPresentationStyle = .custom
                addToWatchlistPopup.transitioningDelegate = addToWatchlistPopup
                addToWatchlistPopup.presentingVC = self
                addToWatchlistPopup.viewControllers[0].setObjectsWithQueryParameters(params)
                
                presentPopUpViewWithNib(addToWatchlistPopup)
            }
            
        }
    }
    
    func backButtonPressOnDetailView() {
        
        if let splitVC  = currentPresentedViewController as? UniversalAppSplitViewController {
            
            if splitVC.isCollapsed {
                
                if let anyVC = splitVC.viewControllers[splitVC.viewControllers.count-1] as? CustomNavigationViewController {
                    
                    if anyVC.viewControllers.count > 1 {
                        anyVC.popViewController(animated: true)
                    } else {
                        if let topVC = anyVC.topViewController as? CustomNavigationViewController {
                            topVC.popViewController(animated: true)
                        }
                    }
                    
                }
                
            } else {
                for eachVC in splitVC.viewControllers {
                    if let customNav = eachVC as? CustomNavigationViewController, let _ = customNav.viewControllers[0] as? GenericDetailViewController {
                        customNav.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func openHelpAndSupportView() {
        openMasterPopup(storyboardIdentifier: .Settings, vcIdentifier: "helpAndSupportVC", navIdentifier: "helpAndSupportNav")
    }
    
    func openProfileEditView() {
        openMasterPopup(storyboardIdentifier: .Settings, vcIdentifier: "editProfileVC", navIdentifier: "editProfileNav")
    }
    
    func openTVistPremiumView() {
        if let currentUser = MyAccountDataProvider.sharedDataProvider.currentUser {
            if currentUser.isPremium() {
                
                let manageSubscriptionUri: String = "itms-apps://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions"
                
                if let url = URL(string: manageSubscriptionUri) {
                    UIApplication.shared.openURL(url)
                }
                
                return
            }
        }
        
        openMasterPopup(storyboardIdentifier: .User, vcIdentifier: "PremiumViewVC", navIdentifier: "PremiumViewNav")
    }
    
    func openTimeZoneSelectionView() {
        openMasterPopup(storyboardIdentifier: StoryBoardIdentifier.Settings, vcIdentifier: "TimeZoneSelectionVC", navIdentifier: "TimeZoneSelectionNav")
    }
    
    func openAlertOptionsView() {
        openMasterPopup(storyboardIdentifier: StoryBoardIdentifier.Settings, vcIdentifier: "alertOptionsVC", navIdentifier: "alertOptionsNav")
    }
    
    func openMasterPopup(storyboardIdentifier: StoryBoardIdentifier, vcIdentifier: String, navIdentifier: String, queryParams: [String:Any]?=nil) {
        
        if let _ = self.currentPresentedViewController as? CustomNavigationViewController {
            pushViewControllerOf(storyboard: storyboardIdentifier, forIdentifier: vcIdentifier, queryParams: queryParams)
        } else {
            var params:[String:Any] = [:]
            if let queryParams = queryParams {
                params = queryParams
            }
            params["addDoneButton"] = true
            
            presentViewControllerOf(storyboardIdentifier, viewControllerIdentifier: navIdentifier, asPopover: true, queryParams: ["addDoneButton": true])
        }
    }
    
    func switchDetailViewWithAction(action: UniversalScreenManagerAction, params: [String: Any]? = nil) {
        
        if let splitVC  = currentPresentedViewController as? UniversalAppSplitViewController {
         
            if let queryParams = params, let isTopVC = queryParams["isTopVC"] as? Bool {
                if !isTopVC {
                    if let detailVC = getMainViewForAction(action: action) {
                     
                        pushViewController(viewController: detailVC, queryParams: queryParams)
                        return
                    }
                }
            }
            
            var detailVC:UIViewController? = self.detailViewReference[action] as? CustomNavigationViewController
            
            if detailVC == nil {
                detailVC = getMainViewForAction(action: action)
            } else {
                if let detailNav = detailVC as? CustomNavigationViewController {
                    detailNav.popToRootViewController(animated: false)
                    if let topVC = detailNav.viewControllers[0] as? GenericDetailViewController {
                        topVC.reset()
                    }
                }
                
                if let detailVC = detailVC as? GenericDetailViewController {
                    detailVC.reset()
                }
            }
            
            if let detailVC = detailVC {
                if let queryParams = params {
                    if let detailNav = detailVC as? CustomNavigationViewController {
                        if let topVC = detailNav.viewControllers[0] as? GenericDetailViewController {
                            topVC.setObjectsWithQueryParameters(queryParams)
                        }
                    }
                    
                    if let detailVC = detailVC as? GenericDetailViewController {
                        detailVC.setObjectsWithQueryParameters(queryParams)
                    }
                }
                
                splitVC.changeSecondaryViewController(viewController: detailVC)
                self.detailViewReference[action] = detailVC
            }
        }
    }
    
    fileprivate func presentPopUpViewWithNib( _ viewController : UIViewController){
        
        
        currentPresentedViewController.present(viewController, animated: true, completion: nil)
        self.presentedViewControllers.append(viewController)
        self.currentPresentedViewController = viewController
    }
    
    // In Multi Window state, Top View Controller would return Top Detail View Controller (Right Pane)
    func getTopViewController() -> UIViewController {
        if currentPresentedViewController != nil {
            if let splitVC  = currentPresentedViewController as? UniversalAppSplitViewController {
                
                if splitVC.isCollapsed {
                    
                    if let anyVC = splitVC.viewControllers[splitVC.viewControllers.count-1] as? CustomNavigationViewController {
                        
                        if let topVC = anyVC.topViewController as? CustomNavigationViewController {
                            return topVC.topViewController!
                        }
                        
                        return anyVC.topViewController!
                    }
                    
                } else {
                    for eachVC in splitVC.viewControllers {
                        if let customNav = eachVC as? CustomNavigationViewController, let _ = customNav.viewControllers[0] as? GenericDetailViewController {
                            return customNav.topViewController!
                        }
                    }
                }
            }
            
            if let selectedNav = currentPresentedViewController as? CustomNavigationViewController {
                return selectedNav.topViewController!
            }
        }
        
        return self
    }
    
    
    func openSafariWithUrl(url: URL, readerMode: Bool) {
        let safari = SFSafariViewController(url: url, entersReaderIfAvailable: readerMode)
        
        currentPresentedViewController.present(safari, animated: true, completion: nil)
    }
    
    
    func makeToast(toastStr: String) {
        presentToast = UIApplication.shared.keyWindow
        if let toast = self.presentToast {
            toast.makeToast(message: toastStr, duration: 3.0, position: HRToastPositionDefault as AnyObject)
        }
    }
    
    func openUserSettingsView() {
        presentViewControllerOf(.User, viewControllerIdentifier: "settingsVC", asPopover: true, queryParams: ["addDoneButton": true])
    }
    
    func openLoginView() {
        openMasterPopup(storyboardIdentifier: .Onboarding, vcIdentifier: "EmailLoginVC", navIdentifier: "signupNav", queryParams: ["screen":"popup", "login":true])
    }
    
    func openSignUpView() {
        openMasterPopup(storyboardIdentifier: .Onboarding, vcIdentifier: "EmailLoginVC", navIdentifier: "signupNav", queryParams: ["screen":"popup"])
    }
    
    func openUserView() {
        guard let splitVC = currentPresentedViewController as? UniversalAppSplitViewController else {
            return
        }
        
        if splitVC.isCollapsed {
            if let parentNav = splitVC.viewControllers[splitVC.viewControllers.count-1] as? CustomNavigationViewController {
                parentNav.popToRootViewController(animated: true)
            }
        } else {
            
            if let action = splitVC.displayModeButtonItem.action, let target = splitVC.displayModeButtonItem.target {
                UIApplication.shared.sendAction(action, to: target, from: self, for: nil)
            }
        }
    }
    
    func showAlert(alert: UIAlertController) {
        currentPresentedViewController.present(alert, animated: true, completion: nil)
    }
    
    
    fileprivate func pushInitialViewControllerOf(storyboard: StoryBoardIdentifier, queryParams: [String: Any]? = nil) {
        if let initialVC = initialViewControllerFor(storyboard) {
            pushViewController(viewController: initialVC, queryParams: queryParams)
        }
    }
    
    fileprivate func pushViewControllerOf(storyboard: StoryBoardIdentifier, forIdentifier: String, queryParams: [String: Any]? = nil) {
        if let viewController = instantiateViewControllerWith(storyboard, forIdentifier: forIdentifier) {
            pushViewController(viewController: viewController, queryParams: queryParams)
        }
    }
    
    
    fileprivate func pushViewController(viewController: UIViewController, queryParams: [String: Any]?) {
        
        if let queryParams = queryParams {
            viewController.setObjectsWithQueryParameters(queryParams)
        }
        
        if let _ = self.currentPresentedViewController {
            
            if let splitVC  = currentPresentedViewController as? UniversalAppSplitViewController {
                if splitVC.isCollapsed {
                    
                    if let anyVC = splitVC.viewControllers[splitVC.viewControllers.count-1] as? CustomNavigationViewController {
                        
                        if let topVC = anyVC.topViewController as? CustomNavigationViewController {
                            topVC.pushViewController(viewController, animated: true)
                            return
                        }
                        anyVC.pushViewController(viewController, animated: true)
                        return
                    }
                } else {
                    
                    for eachVC in splitVC.viewControllers {
                        if let customNav = eachVC as? CustomNavigationViewController, let _ = customNav.viewControllers[0] as? GenericDetailViewController {
                            customNav.pushViewController(viewController, animated: true)
                            return
                        }
                    }
                }
            }
            
            
            if let selectedNav = currentPresentedViewController as? CustomNavigationViewController {
                selectedNav.pushViewController(viewController, animated: true)
                return
            }
        }
    }
    
    func dismissAllPresented() {
        
        for controller in presentedViewControllers.reversed() {
            if controller is UniversalScreenManagerViewController {
                self.currentPresentedViewController = controller
                presentedViewControllers = [controller]
                perform(#selector(UniversalScreenManagerViewController.rebootView), with: nil, afterDelay: 0.25)
                
            } else {
                controller.dismiss(animated: false, completion: nil)
            }
        }
        
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
    func guestUserLoggedIn(isFreshInstall: Bool) {
        
        AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceSessionGenerated)
        
        if isFreshInstall {
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openTimeZoneSelectionView, queryParams: ["fromScreenVader": true])
        } else {
            initialViewBootUp()
        }
        
    }
    
    func userAlreadyExists(registeredUsers: [MyAccountItems]) {
        presentRootViewControllerOf(.Onboarding, asPopover: true, queryParams: nil)
    }
}
