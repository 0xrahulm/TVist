//
//  ScreenVader.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum ScreenManagerAction : String{
    case MainTab = "MainTab"
    
    case HomeTab = "Home"
    case DiscoverTab = "Discover"
    case MyAccountTab = "MyAccount"
    
}

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
    
    

}
