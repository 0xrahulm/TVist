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
    
    func getDeviceID () -> String{
        
        if let keyDict = Locksmith.loadDataForUserAccount("Escape-X"){
            if let id = keyDict["X-Device-ID"]{
                return id as! String
            }else{
                return generateID()
            }
        }else{
            return generateID()
            
        }
        
    }
    
    func generateID() -> String{
        
        let id = UIDevice.currentDevice().identifierForVendor!.UUIDString
        try! Locksmith.saveData(["X-Device-ID":id], forUserAccount: "Escape-X")
        return id

        
    }
    func getXauth()->String?{
        
        if ECUserDefaults.isLoggedIn(){
            if let authDict = Locksmith.loadDataForUserAccount("Escape-X-Auth"){
                if let auth = authDict["X-Auth"] as? String{
                    return auth
                }
            }
            
        }
        
        return nil
        
    }

}
