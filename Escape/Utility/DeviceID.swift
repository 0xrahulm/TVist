//
//  DeviceID.swift
//  Escape
//
//  Created by Ankit on 25/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Locksmith

class DeviceID: NSObject {
    
     static let kEscapeXmodel = "Escape-X"
     static let kEscapeXdevicekey = "X-Device-ID"
    
     static let kEscapeXauthModel = "Escape-X-Auth"
     static let kEscapeXauthkeys = "X-Auth"
    
    
    class func getDeviceID () -> String{
        
        if let keyDict = Locksmith.loadDataForUserAccount(kEscapeXmodel){
            if let id = keyDict[kEscapeXdevicekey]{
                return id as! String
            }else{
                return generateID()
            }
        }else{
            return generateID()
            
        }
        
    }
    
    class func generateID() -> String{
        
        let id = UIDevice.currentDevice().identifierForVendor!.UUIDString
        try! Locksmith.saveData([kEscapeXdevicekey:id], forUserAccount: kEscapeXmodel)
        return id

        
    }
    class func getXauth()->String?{
        
        if ECUserDefaults.isLoggedIn(){
            if let authDict = Locksmith.loadDataForUserAccount(kEscapeXauthModel){
                if let auth = authDict["X-Auth"] as? String{
                    return auth
                }
            }
            
        }
        
        return nil
        
    }
    class func saveXauth(token : String){
        
        if let authDict = Locksmith.loadDataForUserAccount(kEscapeXauthModel){
            if let _ = authDict[kEscapeXauthkeys] as? String{
                try! Locksmith.updateData([kEscapeXauthkeys : token], forUserAccount: kEscapeXauthModel)
            }else{
                try! Locksmith.saveData([kEscapeXauthkeys : token], forUserAccount: kEscapeXauthModel)
            }
        }else{
            try! Locksmith.saveData([kEscapeXauthkeys : token], forUserAccount: kEscapeXauthModel)
        }
        
    }

}
