//
//  PreferenceSingleSelectionViewController.swift
//  TVist
//
//  Created by Rahul Meena on 19/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class PreferenceSingleSelectionViewController: UITableViewController {
    
    var preference:UserPreferenceKey!
    
    func preferenceValues() -> [String] {
        
        // To be overridden
        return UserPreferenceVader.shared.optionsForPreference(preference: preference)
    }
    
    func titleValuesForPreference(preferenceVal: String) -> String? {
        // To be overriden
        
        return UserPreferenceVader.shared.getTitleForPreference(preference: preference, value: preferenceVal)
    }
    
    func currentValueForPreference() -> Any? {
        return UserPreferenceVader.shared.valueForStoredKey(preference)
    }
    
    func defaultSelectedIndex() -> Int {
        if let valueForPref = currentValueForPreference() as? String, let index = preferenceValues().index(of: valueForPref) {
            return index
        }
        return 0
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectDefaultTableViewRows()
    }
    
    func selectDefaultTableViewRows() {
        tableView.selectRow(at: IndexPath(row: defaultSelectedIndex(), section: 0), animated: false, scrollPosition: .top)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return preferenceValues().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prefValue = preferenceValues()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCellIdentifiers.singleSelectionCell.rawValue, for: indexPath) as! SingleSelectionTableViewCell
        
        if let title = titleValuesForPreference(preferenceVal: prefValue) {
            
            cell.setupSettingsCell(title: title)
        }
        
        
        if indexPath.row == preferenceValues().count-1 {
            cell.makeBottomLineFull()
        }
        
        cell.upperLine.isHidden = indexPath.row != 0
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let prefValue = preferenceValues()[indexPath.row]
        
        if let title = titleValuesForPreference(preferenceVal: prefValue), let selectionTitle = self.title {
            ScreenVader.sharedVader.makeToast(toastStr: "\(selectionTitle): \(title)")
        }
        
        UserDataProvider.sharedDataProvider.setPreferenceFor(key: preference, value: prefValue)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
