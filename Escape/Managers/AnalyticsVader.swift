//
//  AnalyticsVader.swift
//  Escape
//
//  Created by Rahul Meena on 18/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class AnalyticsVader: NSObject {
    
    static let sharedVader = AnalyticsVader()
    
    func onboardingStarted() {
        Flurry.logEvent(EventName.onboardingScreen.rawValue, timed: true)
    }
    
    func onboardingFinished() {
        Flurry.endTimedEvent(EventName.onboardingScreen.rawValue, withParameters:[:])
    }
    
    func continueWtihFBTapped(screenName: String) {
        Flurry.logEvent(EventName.continueWithFB.rawValue, withParameters: ["screen_name":screenName])
    }
    
    func basicEvents(eventName: EventName) {
        Flurry.logEvent(eventName.rawValue)
    }
    
    func addToEscapeOpened(escapeName: String, escapeId: String, escapeType: String) {
        Flurry.logEvent(EventName.AddToEscapeOpened.rawValue, withParameters: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType])
    }
    
    func addToEscapeDone(escapeName: String, escapeId: String, escapeType: String, escapeAction: String) {
        Flurry.logEvent(EventName.AddToEscapeDone.rawValue, withParameters: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType, "escape_action": escapeAction])
    }
    
    func itemDescriptionOpened(escapeName: String, escapeId: String, escapeType: String) {
        Flurry.logEvent(EventName.EscapeDescriptionOpened.rawValue, withParameters: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType], timed: true)
    }
    
    func itemDescriptionClosed(escapeName: String, escapeId: String, escapeType: String) {
        Flurry.endTimedEvent(EventName.onboardingScreen.rawValue, withParameters:["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType])
    }
    
    func shareWithFriendsTapped(escapeName: String, escapeId: String, escapeType: String) {
        Flurry.logEvent(EventName.ShareWithFriendsTapped.rawValue, withParameters: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType])
    }
    
    func interestsSelected(totalCount: Int) {
        Flurry.logEvent(EventName.interestsSelected.rawValue, withParameters: ["total_selected":totalCount])
    }
    
    func searchOccurred(searchType: String, searchTerm: String) {
        Flurry.logEvent(EventName.SearchOccurred.rawValue, withParameters: ["search_type": searchType, "search_term":searchTerm])
    }
}
