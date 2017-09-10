//
//  LocalStorageVader.swift
//  Escape
//
//  Created by Rahul Meena on 23/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

let kMizzleAppGroupName = "group.com.ardourlabs.mizzle"

enum LocalStorageKey:String {
    case InterestsSelected = "InterestsSelected"
    case PushToken = "PushToken"
    case DontShowRemoteConnectBanner = "DontShowRemoteConnectBanner"
    case RemoteConnectURI = "RemoteConnectionUri"
    case LastOpenScreen = "LastOpenScreen"
}

class LocalStorageVader: NSObject {
    static let sharedVader = LocalStorageVader()
    
    
    func defaultStorage() -> UserDefaults {
        
        if let groupUserDefault = UserDefaults(suiteName: kMizzleAppGroupName) {
            return groupUserDefault
        }
        
        return UserDefaults.standard
    }
    
    func storeValueInKey(_ storageKey:LocalStorageKey, value: Any) {
        defaultStorage().set(value, forKey: storageKey.rawValue)
    }
    
    func valueForStoredKey(_ storageKey:LocalStorageKey) -> Any? {
        return defaultStorage().value(forKey: storageKey.rawValue)
    }
    
    func flagValueForKey(_ storageKey:LocalStorageKey) -> Bool {
        if let valueForKey = valueForStoredKey(storageKey) as? Bool {
            return valueForKey
        }
        return false
    }
    
    func valuePresentForKey(_ storageKey:LocalStorageKey) -> Bool {
        if let _ = valueForStoredKey(storageKey) {
            return true
        }
        return false
    }
    
    func setFlagForKey(_ storageKey:LocalStorageKey) {
        storeValueInKey(storageKey, value: true)
    }
    
    func removeValueForKey(_ storageKey:LocalStorageKey) {
        defaultStorage().removeObject(forKey: storageKey.rawValue)
    }
}

