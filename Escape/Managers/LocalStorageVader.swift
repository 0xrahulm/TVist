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
}

class LocalStorageVader: NSObject {
    static let sharedVader = LocalStorageVader()
    
    func storeValueInKey(storageKey:LocalStorageKey, value: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: storageKey.rawValue)
    }
    
    func valueForStoredKey(storageKey:LocalStorageKey) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().valueForKey(storageKey.rawValue)
    }
    
    func flagValueForKey(storageKey:LocalStorageKey) -> Bool {
        if let valueForKey = valueForStoredKey(storageKey) as? Bool {
            return valueForKey
        }
        return false
    }
    
    func valuePresentForKey(storageKey:LocalStorageKey) -> Bool {
        if let _ = valueForStoredKey(storageKey) {
            return true
        }
        return false
    }
    
    func setFlagForKey(storageKey:LocalStorageKey) {
        storeValueInKey(storageKey, value: true)
    }
    
    func removeValueForKey(storageKey:LocalStorageKey) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(storageKey.rawValue)
    }
}

