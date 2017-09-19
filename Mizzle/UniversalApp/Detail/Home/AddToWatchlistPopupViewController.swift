//
//  AddToWatchlistPopupViewController.swift
//  TVist
//
//  Created by Rahul Meena on 18/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class AddToWatchlistPopupViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mediaNameLabel: UILabel!
    @IBOutlet weak var mediaYearLabel: UILabel!
    @IBOutlet weak var mediaPosterImageView: UIImageView!
    
    var mediaItem: EscapeItem!
    
    var alertOptions = [
        SettingItem(title: "Enable Alerts", type: .onOffSetting, action: nil),
        SettingItem(title: "Alert Options", type: .regular, action: .openAlertOptionsView)
    ]
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let mediaItem = queryParams["mediaItem"] as? EscapeItem {
            self.mediaItem = mediaItem
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaNameLabel.text = mediaItem.name
        self.mediaYearLabel.text = mediaItem.year
        self.mediaPosterImageView.downloadImageWithUrl(mediaItem.posterImage, placeHolder: nil)
        
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
        
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func didTapOnCancelButton() {
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: nil)
        }
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
        
        cell.upperLine.isHidden = indexPath.row != 0
        
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
}
