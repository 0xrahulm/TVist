//
//  DeviceID.swift
//  Escape
//
//  Created by Ankit on 25/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Locksmith
import KeychainSwift

class DeviceID: NSObject {
    static let kEscapeXmodel = "Escape-X"
    static let kEscapeDeviceKey = "X-Device-ID"
    static let kEscapeXauthModel = "Escape-X-Auth"
    static let kEscapeXauthkeys = "X-Auth"
    
    class func keyChainAccess() -> KeychainSwift {
        
        let keychain = KeychainSwift()
        keychain.accessGroup = "GZM8S25H55.\(kMizzleAppGroupName)"
        
        return keychain
    }
    
    class func getDeviceID() -> String {
        if let id = keyChainAccess().get(kEscapeDeviceKey) {
            return id
        } else if let keyDict = Locksmith.loadDataForUserAccount(userAccount: kEscapeXmodel) {
            // This migrates the old users to new App Group
            if let id = keyDict[kEscapeDeviceKey] as? String {
                
                keyChainAccess().set(id, forKey: kEscapeDeviceKey)
                
                return id
            }
        }
        
        return generateID()
    }
    
    class func generateID() -> String{
        
        let id = UIDevice.current.identifierForVendor!.uuidString
        keyChainAccess().set(id, forKey: kEscapeDeviceKey)
        return id

    }
    
    class func getXauth()->String?{
        
        if ECUserDefaults.isLoggedIn(){
            if let xAuth = keyChainAccess().get(kEscapeXauthkeys) {
                return xAuth
            } else if let authDict = Locksmith.loadDataForUserAccount(userAccount: kEscapeXauthModel, inService: kMizzleAppGroupName){
                if let auth = authDict[kEscapeXauthkeys] as? String{
                    keyChainAccess().set(auth, forKey: kEscapeXauthkeys)
                    return auth
                }
            }
            
        }
        
        return nil
        
    }
    
    class func saveXauth(_ token : String){
        
        if let _ = keyChainAccess().get(kEscapeXauthkeys) {
            keyChainAccess().delete(kEscapeXauthkeys)
        }
        keyChainAccess().set(token, forKey: kEscapeXauthkeys)
    }

}
