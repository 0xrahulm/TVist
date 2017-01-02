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
    
    func performScreenManagerAction(action: ScreenManagerAction, queryParams: [String:AnyObject]?) {
        
        if screenManagerVC != nil {
            screenManagerVC!.performScreenManagerAction(action, params: queryParams)
        } else {
            //self.pendingScreenManagerAction = action
            //self.pendingQueryParams = queryParams
        }
    }
    
    func switchMainTab(action : ScreenManagerAction){
        if screenManagerVC != nil {
            screenManagerVC!.switchTabForAction(action)
        } else {
            //self.pendingScreenManagerAction = action
            //self.pendingQueryParams = queryParams
        }
    }
    func performLogout(){
        if screenManagerVC != nil {
            screenManagerVC!.performLogout()
        }
    }
    
    func removeDismissedViewController(dismissVC: UIViewController) {
        if let screenManagerVC = screenManagerVC {
            screenManagerVC.removePresentedViewController(dismissVC)
            
        }
    }
    
    func hideTabBar(hide: Bool) {
        if let screenManagerVC = screenManagerVC {
            screenManagerVC.hideTabBar(hide)
        }
    }
    
    func changeStatusBarPreference(shouldBeBlack: Bool) {
        if let screenManagerVC = screenManagerVC {
            screenManagerVC.changeStatusBarPreference(shouldBeBlack)
        }
    }
    
    func processDeepLink(deepLinkString : String){
        if let deepLinkUrl = NSURL(string: deepLinkString) {
            processDeepLinkUrl(deepLinkUrl)
        }
    }
    
    func processDeepLinkUrl(deepLinkUrl: NSURL) {
        
        if let pathString = deepLinkUrl.path where pathString.characters.count > 0 {
            print(pathString)
            var pathComponents = pathString.componentsSeparatedByString("/")
            
            if pathComponents.count > 1{
                pathComponents.removeFirst()
                if let action = pathComponents.first{
                    if let screenManagerAction = ScreenManagerAction(rawValue: action){
                        
                        let deepLinkQueryParams : [String:AnyObject]? = getQueryParamsForString(deepLinkUrl.query)
                        
                        performScreenManagerAction(screenManagerAction, queryParams: deepLinkQueryParams)
                
                    }
                }
            }
        }
    }
    
    private func getQueryParamsForString(queryString: String?) -> [String: AnyObject]? {
        
        var queryParams: [String:AnyObject]?
        
        if let queryString = queryString {
            let queryComponenets = queryString.componentsSeparatedByString("&")
            if queryComponenets.count > 0 {
                queryParams = [:]
                for queryComp in queryComponenets {
                    let queryKVPString = queryComp.componentsSeparatedByString("=")
                    
                    if queryKVPString.count > 1 {
                        queryParams![queryKVPString[0]] = queryKVPString[1]
                    }
                }
            }
        }
        
        return queryParams
    }

}
