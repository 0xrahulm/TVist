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
    var universalScreenManagerVC: UniversalScreenManagerViewController?
    
    
    var pendingUniversalScreenManagerAction: UniversalScreenManagerAction?
    var pendingScreenManagerAction: ScreenManagerAction?
    var pendingQueryParams: [String: Any]?
    
    func performUniversalScreenManagerAction(_ action: UniversalScreenManagerAction, queryParams: [String:Any]?) {
        
        if universalScreenManagerVC != nil {
            universalScreenManagerVC!.performScreenManagerAction(action, params: queryParams)
        } else {
            self.pendingUniversalScreenManagerAction = action
            self.pendingQueryParams = queryParams
        }
    }
    
    func performScreenManagerAction(_ action: ScreenManagerAction, queryParams: [String:Any]?) {
        
        if screenManagerVC != nil {
            screenManagerVC!.performScreenManagerAction(action, params: queryParams)
        } else {
            self.pendingScreenManagerAction = action
            self.pendingQueryParams = queryParams
        }
    }
    
    func loginActionAfterDelay() {
        // nothing here
    }
    
    func loginAction() {
        if let screenManagerVC = screenManagerVC {
            screenManagerVC.dismissAllPresented()
        }
        
        if let universalScreenManagerVC = self.universalScreenManagerVC {
            universalScreenManagerVC.dismissAllPresented()
        }
    }
    
    func switchMainTab(_ action : ScreenManagerAction){
        if screenManagerVC != nil {
            screenManagerVC!.switchTabForAction(action)
        } else {
            self.pendingScreenManagerAction = nil
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
        
        if let universalScreenManagerVC = self.universalScreenManagerVC {
            universalScreenManagerVC.removePresentedViewController(dismissVC)
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
        
        if let universalScreenManagerVC = universalScreenManagerVC {
            universalScreenManagerVC.showAlert(alert: alert)
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
    
    func backButtonPressOnDetailView() {
        if let universalVC = self.universalScreenManagerVC {
            universalVC.backButtonPressOnDetailView()
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
    
    func rebootView() {
        if let universalScreenManagerVC = self.universalScreenManagerVC {
            universalScreenManagerVC.rebootView()
        }
    }

    func openSafariWithUrl(url: URL, readerMode: Bool) {
        if let screenManagerVC = self.screenManagerVC {
            screenManagerVC.openSafariWithUrl(url: url, readerMode: readerMode)
        }
        
        if let universalSMVC = self.universalScreenManagerVC {
            universalSMVC.openSafariWithUrl(url: url, readerMode: readerMode)
        }
    }
    
    func makeToast(toastStr: String) {
        if let screenManagerVC = self.screenManagerVC {
            screenManagerVC.makeToast(toastStr: toastStr)
        }
        if let universalScreenManagerVC = self.universalScreenManagerVC {
            universalScreenManagerVC.makeToast(toastStr: toastStr)
        }
    }
}
