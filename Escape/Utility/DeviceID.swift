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
     static let kEscapeDeviceKey = "X-Device-ID"
    
     static let kEscapeXauthModel = "Escape-X-Auth"
     static let kEscapeXauthkeys = "X-Auth"
    
    
    class func getDeviceID () -> String{
        
        if let keyDict = Locksmith.loadDataForUserAccount(userAccount: kEscapeXmodel){
            if let id = keyDict[kEscapeDeviceKey]{
                return id as! String
            }else{
                return generateID()
            }
        }else{
            return generateID()
            
        }
        
    }
    
    class func generateID() -> String{
        
        let id = UIDevice.current.identifierForVendor!.uuidString
        try! Locksmith.saveData(data: [kEscapeDeviceKey:id], forUserAccount: kEscapeXmodel)
        return id

        
    }
    class func getXauth()->String?{
        
        if ECUserDefaults.isLoggedIn(){
            if let authDict = Locksmith.loadDataForUserAccount(userAccount: kEscapeXauthModel, inService: kMizzleAppGroupName){
                if let auth = authDict["X-Auth"] as? String{
                    return auth
                }
            }
            
        }
        
        return nil
        
    }
    class func saveXauth(_ token : String){
        
        if let authDict = Locksmith.loadDataForUserAccount(userAccount: kEscapeXauthModel, inService: kMizzleAppGroupName){
            if let _ = authDict[kEscapeXauthkeys] as? String{
                try! Locksmith.updateData(data: [kEscapeXauthkeys : token], forUserAccount: kEscapeXauthModel, inService: kMizzleAppGroupName)
            }else{
                try! Locksmith.saveData(data: [kEscapeXauthkeys : token], forUserAccount: kEscapeXauthModel, inService: kMizzleAppGroupName)
            }
        }else{
            try! Locksmith.saveData(data: [kEscapeXauthkeys : token], forUserAccount: kEscapeXauthModel, inService: kMizzleAppGroupName)
        }
        
    }

}
