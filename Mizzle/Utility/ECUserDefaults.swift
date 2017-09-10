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
    static let kSearchText = "kSearchTextKey"
    
    
    class func isLoggedIn()-> Bool{
        let defaults = LocalStorageVader.sharedVader.defaultStorage()
        return defaults.bool(forKey: kLoggedIn)
    }
    
    class func setLoggedIn(_ value : Bool){
        let defaults = LocalStorageVader.sharedVader.defaultStorage()
        defaults.set(value, forKey: kLoggedIn)
        
    }
    
    class func getCurrentUserId() -> String?{
        let defaults = LocalStorageVader.sharedVader.defaultStorage()
        return defaults.value(forKey: kCurrentUserId) as? String
    }
    class func setCurrentUserId(_ id : String){
        let defaults = LocalStorageVader.sharedVader.defaultStorage()
        defaults.setValue(id, forKey: kCurrentUserId)
    }
    
    class func getSearchedText() -> String?{
        let defaults = LocalStorageVader.sharedVader.defaultStorage()
        return defaults.value(forKey: kSearchText) as? String
    }
    class func setSearchedText(_ id : String){
        let defaults = LocalStorageVader.sharedVader.defaultStorage()
        defaults.setValue(id, forKey: kSearchText)
    }
    class func removeSearchedText(){
        let defaults = LocalStorageVader.sharedVader.defaultStorage()
        defaults.removeObject(forKey: kSearchText)
    }
    
    //Remove keys
    class func removeLoggedInKeys(){
        let defaults = LocalStorageVader.sharedVader.defaultStorage()
        
        defaults.removeObject(forKey: kLoggedIn)
        defaults.removeObject(forKey: kCurrentUserId)
    }

}
