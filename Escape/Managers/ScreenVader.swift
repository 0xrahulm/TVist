//
//  ScreenVader.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class ScreenVader: NSObject {
    
    static let sharedVader = ScreenVader()
    
    var screenManagerVC : ScreenManagerViewController?
    
    var pendingScreenManagerAction: ScreenManagerAction?
    var pendingQueryParams: [String: Any]?
    
    func performScreenManagerAction(_ action: ScreenManagerAction, queryParams: [String:Any]?) {
        
        if screenManagerVC != nil {
            screenManagerVC!.performScreenManagerAction(action, params: queryParams)
        } else {
            self.pendingScreenManagerAction = action
            self.pendingQueryParams = queryParams
        }
    }
    
    func loginActionAfterDelay() {
        perform(#selector(ScreenVader.loginAction), with: nil, afterDelay: 3.0)
    }
    
    func loginAction() {
        performScreenManagerAction(.MainTab, queryParams: nil)
    }
    
    func switchMainTab(_ action : ScreenManagerAction){
        if screenManagerVC != nil {
            screenManagerVC!.switchTabForAction(action)
        } else {
            self.pendingScreenManagerAction = action
        }
    }
    func performLogout(){
        if screenManagerVC != nil {
            screenManagerVC!.performLogout()
        }
    }
    
    func removeDismissedViewController(_ dismissVC: UIViewController) {
        if let screenManagerVC = screenManagerVC {
            screenManagerVC.removePresentedViewController(dismissVC)
            
        }
    }
    
    func hideTabBar(_ hide: Bool) {
        if let screenManagerVC = screenManagerVC {
            screenManagerVC.hideTabBar(hide)
        }
    }
    
    func changeStatusBarPreference(_ shouldBeBlack: Bool) {
        if let screenManagerVC = screenManagerVC {
            screenManagerVC.changeStatusBarPreference(shouldBeBlack)
        }
    }
    
    
    func processDeepLink(_ deepLinkString : String){
        if let deepLinkUrl = URL(string: deepLinkString) {
            processDeepLinkUrl(deepLinkUrl, shouldAddToPending: false)
        }
    }
    
    func showAlert(alert: UIAlertController) {
        if let screenManagerVC = screenManagerVC {
            screenManagerVC.showAlert(alert: alert)
        }
    }
    
    func processDeepLink(_ deepLinkString : String, shouldAddToPending: Bool){
        if let deepLinkUrl = URL(string: deepLinkString) {
            processDeepLinkUrl(deepLinkUrl, shouldAddToPending: shouldAddToPending)
        }
    }
    
    func processDeepLinkUrl(_ deepLinkUrl: URL, shouldAddToPending: Bool) {
        let pathString = deepLinkUrl.path
        
        if pathString.characters.count > 0 {
            print(pathString)
            var pathComponents = pathString.components(separatedBy: "/")
            
            if pathComponents.count > 1{
                pathComponents.removeFirst()
                if let action = pathComponents.first{
                    if let screenManagerAction = ScreenManagerAction(rawValue: action){
                        
                        let deepLinkQueryParams : [String:Any]? = getQueryParamsForString(deepLinkUrl.query)
                        
                        if shouldAddToPending {
                            self.pendingScreenManagerAction = screenManagerAction
                            self.pendingQueryParams = deepLinkQueryParams
                        } else {
                            performScreenManagerAction(screenManagerAction, queryParams: deepLinkQueryParams)
                        }
                
                    }
                }
            }
        }
    }
    
    fileprivate func getQueryParamsForString(_ queryString: String?) -> [String: Any]? {
        
        var queryParams: [String:Any]?
        
        if let queryString = queryString {
            let queryComponenets = queryString.components(separatedBy: "&")
            if queryComponenets.count > 0 {
                queryParams = [:]
                for queryComp in queryComponenets {
                    let queryKVPString = queryComp.components(separatedBy: "=")
                    
                    if queryKVPString.count > 1 {
                        queryParams![queryKVPString[0]] = queryKVPString[1]
                    }
                }
            }
        }
        
        return queryParams
    }

}
