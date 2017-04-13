//
//  LocalStorageVader.swift
//  Escape
//
//  Created by Rahul Meena on 23/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum LocalStorageKey:String {
    case InterestsSelected = "InterestsSelected"
    case PushToken = "PushToken"
}

class LocalStorageVader: NSObject {
    static let sharedVader = LocalStorageVader()
    
    func storeValueInKey(_ storageKey:LocalStorageKey, value: Any) {
        UserDefaults.standard.set(value, forKey: storageKey.rawValue)
    }
    
    func valueForStoredKey(_ storageKey:LocalStorageKey) -> Any? {
        return UserDefaults.standard.value(forKey: storageKey.rawValue)
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
        UserDefaults.standard.removeObject(forKey: storageKey.rawValue)
    }
}

