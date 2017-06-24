//
//  AnalyticsVader.swift
//  Escape
//
//  Created by Rahul Meena on 18/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import Mixpanel

class AnalyticsVader: NSObject {
    
    static let sharedVader = AnalyticsVader()
    
    override init() {
        super.init()
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser, let userId = user.id {
            Mixpanel.mainInstance().identify(distinctId: userId)
            Mixpanel.mainInstance().people.set(property: "userType", to: user.userType)
        }
    }
    
    func onboardingStarted() {
        timedEventStart(eventName: EventName.onboardingScreen)
    }
    
    func onboardingFinished() {
        timedEventEnd(eventName: EventName.onboardingScreen)
    }
    
    func continueWtihFBTapped(screenName: String) {
        sendEvent(eventName: EventName.continueWithFB.rawValue, properties: ["screen_name":screenName])
    }
    
    func basicEvents(eventName: EventName) {
        basicEvents(eventName: eventName, properties: nil)
    }
    
    func basicEvents(eventName: EventName, properties: [String:String]?) {
        sendEvent(eventName: eventName.rawValue, properties: properties)
    }
    
    func addToEscapeOpened(escapeName: String, escapeId: String, escapeType: String) {
        sendEvent(eventName: EventName.AddToEscapeOpened.rawValue, properties: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType])
    }
    
    func addToEscapeDone(escapeName: String, escapeId: String, escapeType: String, escapeAction: String) {
        sendEvent(eventName: EventName.AddToEscapeDone.rawValue, properties: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType, "escape_action": escapeAction])
    }
    
    func itemDescriptionOpened(escapeName: String, escapeId: String, escapeType: String) {
        timedEventStart(eventName: EventName.ItemDescriptionOpened)
    }
    
    func trackButtonClicked(escapeName: String, escapeId: String, escapeType: String, position: String) {
        sendEvent(eventName: EventName.TrackButtonClick.rawValue, properties: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType, "position": position])
    }
    
    func undoTrack(escapeName: String, escapeId: String, escapeType: String, position: String) {
        sendEvent(eventName: EventName.UndoTrack.rawValue, properties: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType, "position": position])
    }
    
    func itemDescriptionClosed(escapeName: String, escapeId: String, escapeType: String) {
        timedEventEnd(eventName: EventName.ItemDescriptionOpened, parameters: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType])
    }
    
    func shareWithFriendsTapped(escapeName: String, escapeId: String, escapeType: String) {
        sendEvent(eventName: EventName.ShareWithFriendsClick.rawValue, properties: ["escape_name": escapeName, "escape_id": escapeId, "escape_type": escapeType])
    }
    
    func interestsSelected(totalCount: Int) {
        sendEvent(eventName: EventName.interestsSelected.rawValue, properties: ["total_selected":"\(totalCount)"])
    }
    
    func searchOccurred(searchType: String, searchTerm: String) {
        sendEvent(eventName: EventName.SearchOccurred.rawValue, properties: ["search_type": searchType, "search_term":searchTerm])
    }
    
    func fbLoginFailure(reason:String) {
        sendEvent(eventName: EventName.facebookLoginFailure.rawValue, properties: ["reason": reason])
    }
    
    func emailLoginIssue(reason: String) {
        sendEvent(eventName: EventName.emailLoginErrorPopup.rawValue, properties: ["reason": reason])
    }

    private
    
    func timedEventStart(eventName:EventName) {
        Flurry.logEvent(eventName.rawValue, timed: true)
        Mixpanel.mainInstance().time(event: eventName.rawValue)
    }
    
    func timedEventEnd(eventName: EventName, parameters:[String:String]=[:]) {
        Flurry.endTimedEvent(eventName.rawValue, withParameters: parameters)
        Mixpanel.mainInstance().track(event: eventName.rawValue, properties: parameters)
    }
    
    func sendEvent(eventName: String, properties: [String:String]?) {
        Flurry.logEvent(eventName, withParameters: properties)
        Mixpanel.mainInstance().track(event: eventName, properties: properties)
    }
}
