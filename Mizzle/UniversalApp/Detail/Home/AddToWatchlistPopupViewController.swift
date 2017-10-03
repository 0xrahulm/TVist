//
//  AddToWatchlistPopupViewController.swift
//  TVist
//
//  Created by Rahul Meena on 18/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol AddToWatchlistPopupProtocol: class {
    func addToWatchlistDone(isAlertSet: Bool)
}

class AddToWatchlistPopupViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mediaNameLabel: UILabel!
    @IBOutlet weak var mediaYearLabel: UILabel!
    @IBOutlet weak var mediaPosterImageView: UIImageView!
    
    var mediaItem: EscapeItem!
    
    var selectedAlertSwitch: Bool = false
    
    weak var delegate: AddToWatchlistPopupProtocol?
    
    var alertOptionsEnabled:Bool = false
    
    var alertOptions:[SettingItem] {
        get {
            return [
                SettingItem(title: "Enable Alerts", type: .onOffSetting, action: nil),
                SettingItem(title: "Alert Options", type: .regular, action: .openAlertOptionsView, subTitle: nil, isEnabled: alertOptionsEnabled)
            ]
        }
    }
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let mediaItem = queryParams["mediaItem"] as? EscapeItem {
            self.mediaItem = mediaItem
        }
        
        if let delegate = queryParams["delegate"] as? AddToWatchlistPopupProtocol {
            self.delegate = delegate
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaNameLabel.text = mediaItem.name
        self.mediaYearLabel.text = mediaItem.year
        self.mediaPosterImageView.downloadImageWithUrl(mediaItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
        self.selectedAlertSwitch = mediaItem.isAlertSet
        
        self.tableView.backgroundColor = UIColor.styleGuideBackgroundColor()
        
    }
    
    func identifierForCellType(type: SettingItemType) -> String {
        
        switch type {
        case .authButton:
            return SettingCellIdentifiers.authCell.rawValue
        case .message:
            return SettingCellIdentifiers.messageCell.rawValue
        case .onOffSetting:
            return SettingCellIdentifiers.onOffCell.rawValue
        case .premiumSetting:
            return SettingCellIdentifiers.premiumCell.rawValue
        default:
            return SettingCellIdentifiers.regularCell.rawValue
        }
        
    }
    
    @IBAction func didTapOnDoneButton() {
        
        WatchlistDataProvider.shared.addEditWatchlist(escapeId: self.mediaItem.id, shouldAlert: self.selectedAlertSwitch)
        
        if let delegate = self.delegate {
            delegate.addToWatchlistDone(isAlertSet: self.selectedAlertSwitch)
        }
        
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: nil)
        }
        
        AnalyticsVader.sharedVader.basicEvents(eventName: .AddToWatchlistDoneButtonTap)
    }
    
    
    @IBAction func didTapOnCancelButton() {
        AnalyticsVader.sharedVader.basicEvents(eventName: .AddToWatchlistCancelButtonTap)
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension AddToWatchlistPopupViewController: SettingsOnOffSwitchProtocol {
    func onOffSwitchValueDidChange(isOn: Bool) {
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
         
            if user.alerts_count > 5 {
                if UserDataProvider.sharedDataProvider.premiumOnlyFeature(feature: .airtimeAlerts) {
                    
                    self.selectedAlertSwitch = isOn
                    self.alertOptionsEnabled = true
                    NotificationsVader.shared.getNotificationPermission()
                }
            } else {
                self.selectedAlertSwitch = isOn
                self.alertOptionsEnabled = true
                NotificationsVader.shared.getNotificationPermission()
            }
        }
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.AddToWatchlistEnableAlerts, properties: ["state":"\(isOn)"])
        
        self.tableView.reloadData()
        
    }
}

extension AddToWatchlistPopupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = alertOptions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierForCellType(type: item.type), for: indexPath) as! SettingsBaseTableViewCell
        cell.settingItem = item
        
        if indexPath.row == alertOptions.count-1 {
            cell.makeBottomLineFull()
        }
        cell.enabledState(isEnabled: item.isEnabled)
        
        cell.upperLine.isHidden = indexPath.row != 0
        
        if item.title == "Enable Alerts" {
            if let switchCell = cell as? SettingsOnOffTableViewCell {
                switchCell.onOffSwitchDelegate = self
                switchCell.onOffSwitch.isOn = self.selectedAlertSwitch
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertOptions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Get Airing Alerts"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = alertOptions[indexPath.row]
        
        if item.title == "Alert Options" {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.AddToWatchlistAlertOptions)
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openAlertOptionsView, queryParams: nil)
        }
    }
}
