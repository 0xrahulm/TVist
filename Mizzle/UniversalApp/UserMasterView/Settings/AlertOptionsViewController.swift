//
//  AlertOptionsViewController.swift
//  TVist
//
//  Created by Rahul Meena on 19/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class AlertOptionsViewController: UITableViewController {
    
    var alertPreferences: [UserPreferenceKey] = [.onlyNewEpisodes, .alertFrequency, .alertBeforeAirtime, .airtimePreference, .airdatePreference]
    
    var titlesForPreference: [UserPreferenceKey: String] = [
        .onlyNewEpisodes: "New Episodes Only",
        .alertFrequency: "Alert Frequency",
        .alertBeforeAirtime: "Get Alerts Before",
        .airtimePreference: "Time Preference",
        .airdatePreference: "Day Preference"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    func identifierForPreference(key: UserPreferenceKey) -> String {
        
        switch key {
        case .onlyNewEpisodes:
            return SettingCellIdentifiers.onOffCell.rawValue
        default:
            return SettingCellIdentifiers.selectedOptionCell.rawValue
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = alertPreferences[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierForPreference(key: item), for: indexPath) as! SettingsBaseTableViewCell
        
        if let prefTitle = titlesForPreference[item] {
            cell.setupSettingsCell(title: prefTitle)
        }
        
        if let selectedOptionCell = cell as? SelectedOptionTableViewCell {
            selectedOptionCell.selectedOptionLabel.text = UserPreferenceVader.shared.valueStringForPreference(preference: item)
        }
        
        if let onOffCell = cell as? SettingsOnOffTableViewCell {
            onOffCell.onOffSwitch.setOn(UserPreferenceVader.shared.flagValueForKey(item), animated: false)
        }
        
        if indexPath.row == alertPreferences.count-1 {
            cell.makeBottomLineFull()
        }
        
        cell.upperLine.isHidden = indexPath.row != 0

        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertPreferences.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Tap to Edit Preference"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = alertPreferences[indexPath.row]
        
        if item == .alertFrequency || item == .alertBeforeAirtime {
            if let prefSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "preferenceSingleSelectionVC") as? PreferenceSingleSelectionViewController {
                prefSelectionVC.preference = item
                prefSelectionVC.title = titlesForPreference[item]
                self.navigationController?.pushViewController(prefSelectionVC, animated: true)
            }
        } else if item == .airdatePreference {
            if let prefMultiSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "preferenceMultiSelectionVC") as? PreferencesMultiSelectionViewController {
                prefMultiSelectVC.preference = item
                prefMultiSelectVC.title = titlesForPreference[item]
                self.navigationController?.pushViewController(prefMultiSelectVC, animated: true)
            }
        }
        
    }

}
