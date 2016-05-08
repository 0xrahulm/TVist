//
//  ECUserDefaults.swift
//  Escape
//
//  Created by Ankit on 25/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class ECUserDefaults: NSObject {
    
    static let kLoggedIn = "loggedInKey"
    static let kCurrentUserId = "currentUserIdKey"
    
    class func isLoggedIn()-> Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(kLoggedIn)
    }
    
    class func setLoggedIn(value : Bool){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(value, forKey: kLoggedIn)
        
    }
    
    class func getCurrentUserId() -> String?{
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey(kCurrentUserId) as? String
    }
    class func setCurrentUserId(id : String){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(id, forKey: kCurrentUserId)
    }
    
    //Remove keys
    class func removeLoggedInKeys(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.removeObjectForKey(kLoggedIn)
        defaults.removeObjectForKey(kCurrentUserId)
    }

}
