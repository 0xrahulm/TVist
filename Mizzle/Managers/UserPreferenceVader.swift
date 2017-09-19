//
//  UserPreferenceVader.swift
//  TVist
//
//  Created by Rahul Meena on 16/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UserPreferenceVader: NSObject {
    static let shared = UserPreferenceVader()
    
    
    func setPreferencesWith(data: [Any]) {
        for eachPref in data {
            if let eachPref = eachPref as? [String: Any] {
                if let alertPref = eachPref[UserPreferenceKey.alertPreference.rawValue] as? Bool {
                    setAlertPreference(preference: alertPref)
                }
                
                if let newEpisodesPref = eachPref[UserPreferenceKey.onlyNewEpisodes.rawValue] as? Bool {
                    setNewEpisodesOnly(preference: newEpisodesPref)
                }
                
                if let alertBeforeAirtimePref = eachPref[UserPreferenceKey.alertBeforeAirtime.rawValue] as? String {
                    setAlertBeforeAirtime(timeString: alertBeforeAirtimePref)
                }
                
                if let alertFrequency = eachPref[UserPreferenceKey.alertFrequency.rawValue] as? String {
                    setAlertFrequency(preference: alertFrequency)
                }
                
                if let timeZonePref = eachPref[UserPreferenceKey.timezonePreference.rawValue] as? String {
                    setTimeZonePreference(tzString: timeZonePref)
                }
                
                if let airtimePref = eachPref[UserPreferenceKey.airtimePreference.rawValue] as? [String] {
                    setAirtimePreference(airtimePreference: airtimePref)
                }
                
                if let airdatePref = eachPref[UserPreferenceKey.airdatePreference.rawValue] as? [String] {
                    setAirdatePreference(airdatePreference: airdatePref)
                }
            }
        }
    }
    
    

    func setAlertPreference(preference: Bool) {
        storeValueInKey(.alertPreference, value: preference)
    }
    
    func getAlertPreference() -> Bool {
        
        if let alertPreference = valueForStoredKey(.alertPreference) as? Bool {
            return alertPreference
        }
        
        return false
    }
    
    
    func setNewEpisodesOnly(preference: Bool) {
        storeValueInKey(.onlyNewEpisodes, value: preference)
    }
    
    func getNewEpisodesOnly() -> Bool {
        
        if let newEpisodesOnly = valueForStoredKey(.onlyNewEpisodes) as? Bool {
            return newEpisodesOnly
        }
        
        return false // default value
    }
    
    func setAlertFrequency(preference: String) {
        storeValueInKey(.alertFrequency, value: preference)
    }
    
    func getAlertFrequency() -> String {
        if let alertFrequency = valueForStoredKey(.alertFrequency) as? String {
            return alertFrequency
        }
        
        return "1"
    }
    
    func setAlertBeforeAirtime(timeString: String) {
        storeValueInKey(.alertBeforeAirtime, value: timeString)
    }
    
    func getAlertBeforeAirtime() -> String {
        
        if let alertBeforeAirtime = valueForStoredKey(.alertBeforeAirtime) as? String {
            return alertBeforeAirtime
        }
        
        return "60" // default value
    }
    
    
    func setTimeZonePreference(tzString: String) {
        storeValueInKey(.timezonePreference, value: tzString)
    }
    
    func getTimeZonePreference() -> TimeZoneIdentifier {
        
        if let timezonePreference = valueForStoredKey(.timezonePreference) as? String {
            
            if let timeZoneIdentifier = TimeZoneIdentifier(rawValue: timezonePreference) {
                return timeZoneIdentifier
            }
        }
        
        return .EasternTimeZone // default value
    }
    
    func setAirtimePreference(airtimePreference: [String]) {
        storeValueInKey(.airtimePreference, value: airtimePreference)
    }
    
    func getAirtimePreference() -> [String] {
        
        if let airtimePreference = valueForStoredKey(.airtimePreference) as? [String] {
            return airtimePreference
        }
        
        return ["8 am", "12 pm"] // default value
    }
    
    func setAirdatePreference(airdatePreference: [String]) {
        storeValueInKey(.airdatePreference, value: airdatePreference)
    }
    
    func getAirdatePreference() -> [String] {
        
        if let airdatePreference = valueForStoredKey(.airdatePreference) as? [String] {
            return airdatePreference
        }
        
        return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] // default value
    }
    
    func optionsForPreference(preference: UserPreferenceKey) -> [String] {
        switch preference {
        case .alertFrequency:
            return ["1", "2", "3", "5", "0"]
        case .alertBeforeAirtime:
            return ["5", "15", "30", "60", "120"]
        case .airdatePreference:
            return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        default:
            return []
        }
    }
    
    func getTitleForPreference(preference: UserPreferenceKey, value: String) -> String? {
        
        switch preference {
        case .alertFrequency:
            if value == "1" {
                return "Once"
            } else if value == "2" {
                return "Twice"
            } else if value == "0" {
                return "Repeat"
            }
            return "\(value) Times"
        case .alertBeforeAirtime:
            if let intVal = Int(value) {
                if intVal >= 60 {
                    return "\(intVal/60) hour"
                }
            }
            return "\(value) Minutes"
        case .airdatePreference:
            return TimeUtility.dayFromShortDay(day: value)
        default:
            return nil
        }
    }
    
    func valueStringForPreference(preference: UserPreferenceKey) -> String? {
        
        switch preference {
        case .alertFrequency:
            return getTitleForPreference(preference: preference, value: getAlertFrequency())
        case .airtimePreference:
            let airtimePref = getAirtimePreference()
            return "\(airtimePref[0]) - \(airtimePref[1])"
        case .alertBeforeAirtime:
            return getTitleForPreference(preference: preference, value: getAlertBeforeAirtime())
        case .airdatePreference:
            let airDates = getAirdatePreference()
            if airDates.count == 7 {
                return "All days"
            } else if airDates.count == 1 {
                return getTitleForPreference(preference: preference, value: airDates[0])
            } else {
                return "\(airDates.count) days"
            }
        default:
            return nil
        }
    }
    
    func defaultStorage() -> UserDefaults {
        
        if let groupUserDefault = UserDefaults(suiteName: kMizzleAppGroupName) {
            return groupUserDefault
        }
        
        return UserDefaults.standard
    }
    
    func keyNameForPreference(userPreference: UserPreferenceKey) -> String {
        if let currentUser = MyAccountDataProvider.sharedDataProvider.currentUser, let currentUserId = currentUser.id {
            return "\(currentUserId)-\(userPreference.rawValue)"
        }
        return userPreference.rawValue
    }
    
    func storeValueInKey(_ storageKey:UserPreferenceKey, value: Any) {
        defaultStorage().set(value, forKey: keyNameForPreference(userPreference: storageKey))
    }
    
    func valueForStoredKey(_ storageKey:UserPreferenceKey) -> Any? {
        return defaultStorage().value(forKey: keyNameForPreference(userPreference: storageKey))
    }
    
    func flagValueForKey(_ storageKey:UserPreferenceKey) -> Bool {
        if let valueForKey = valueForStoredKey(storageKey) as? Bool {
            return valueForKey
        }
        return false
    }
    
    func valuePresentForKey(_ storageKey:UserPreferenceKey) -> Bool {
        if let _ = valueForStoredKey(storageKey) {
            return true
        }
        return false
    }
    
    func setFlagForKey(_ storageKey:UserPreferenceKey) {
        storeValueInKey(storageKey, value: true)
    }
    
    func removeValueForKey(_ storageKey:UserPreferenceKey) {
        defaultStorage().removeObject(forKey: storageKey.rawValue)
    }

}
