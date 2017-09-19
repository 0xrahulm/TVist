//
//  PreferencesMultiSelectionViewController.swift
//  TVist
//
//  Created by Rahul Meena on 19/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class PreferencesMultiSelectionViewController: PreferenceSingleSelectionViewController {
    
    @IBOutlet weak var saveBarButtonItem:UIBarButtonItem!
    
    var _currentValues:[String]?
    
    var currentValuesForPreference: [String] {
        get {
            
            if let _currentValues = self._currentValues {
                return _currentValues
            }
            
            if let currentValues = self.currentValueForPreference() as? [String] {
                return currentValues
            }
            
            return []
        }
        
        set {
            self._currentValues = newValue
        }
        
    }
    
    override func selectDefaultTableViewRows() {
        for (index,eachValue) in preferenceValues().enumerated() {
            if currentValuesForPreference.contains(eachValue) {
                tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .top)
            }
        }
        
        determineSaveButtonFate()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = preferenceValues()[indexPath.row]
        
        var oldValues = self.currentValuesForPreference
        
        oldValues.append(element)
        
        self.currentValuesForPreference = oldValues
        
        determineSaveButtonFate()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let element = preferenceValues()[indexPath.row]
        
        var oldValues = self.currentValuesForPreference
        if let indexOfElement = oldValues.index(of: element) {
            oldValues.remove(at: indexOfElement)
        }
        self.currentValuesForPreference = oldValues
        
        determineSaveButtonFate()
    }
    
    func determineSaveButtonFate() {
        var noChange:Bool = true
        
        if let currentValues = self.currentValueForPreference() as? [String] {
            if currentValues.count != self.currentValuesForPreference.count {
                noChange = false
            } else {
                for eachValue in self.currentValuesForPreference {
                    noChange = currentValues.contains(eachValue)
                    if !noChange {
                        break
                    }
                }
            }
        }
        self.saveBarButtonItem.isEnabled = !noChange
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        UserDataProvider.sharedDataProvider.setPreferenceFor(key: preference, value: self.currentValuesForPreference)
        
        self.navigationController?.popViewController(animated: true)
        
        if let title = UserPreferenceVader.shared.valueStringForPreference(preference: self.preference), let selectionTitle = self.title {
            ScreenVader.sharedVader.makeToast(toastStr: "\(selectionTitle): \(title)")
        }
    }

}
