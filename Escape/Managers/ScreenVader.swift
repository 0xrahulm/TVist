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

}
