//
//  TimeZoneSelectionViewController.swift
//  TVist
//
//  Created by Rahul Meena on 16/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class TimeZoneSelectionViewController: PreferenceSingleSelectionViewController {
    
    var timeZonesToDisplay: [TimeZoneIdentifier] = [.EasternTimeZone, .CentralTimeZone, .MountainTimeZone, .PacificTimeZone]
    
    var titlesForZones: [TimeZoneIdentifier: String] = [
        .EasternTimeZone: "Eastern Time Zone",
        .CentralTimeZone: "Central Time Zone",
        .MountainTimeZone: "Mountain Time Zone",
        .PacificTimeZone: "Pacific Time Zone"
    ]
    
    override func preferenceValues() -> [String] {
        return timeZonesToDisplay.map { $0.rawValue }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.preference = UserPreferenceKey.timezonePreference
    }
    
    override func titleValuesForPreference(preferenceVal: String) -> String? {
        if let timeZoneDisplay = TimeZoneIdentifier(rawValue: preferenceVal), let title = titlesForZones[timeZoneDisplay] {
            return title
        }
        
        return super.titleValuesForPreference(preferenceVal: preferenceVal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Time Zone"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let currentDetectedZone = TimeUtility.getTimeZoneForUser() {
         
            AnalyticsVader.sharedVader.basicEvents(eventName: .TimeZonePreferenceSelectionShown, properties: ["user_time_zone": currentDetectedZone.rawValue])
        } else {
            
            AnalyticsVader.sharedVader.basicEvents(eventName: .TimeZonePreferenceSelectionShown, properties: ["user_time_zone": "unable to detect"])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func didDismissPopup() {
        super.didDismissPopup()
        AnalyticsVader.sharedVader.basicEvents(eventName: .TimeZonePreferenceDoneButtonTap, properties: nil)
        ScreenVader.sharedVader.rebootView()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Supported Time Zones"
    }
}
