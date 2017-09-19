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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didDismissPopup() {
        super.didDismissPopup()
        
        ScreenVader.sharedVader.rebootView()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Supported Time Zones"
    }
}
