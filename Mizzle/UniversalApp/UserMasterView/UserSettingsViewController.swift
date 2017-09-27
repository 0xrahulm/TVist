//
//  UserSettingsViewController.swift
//  TVist
//
//  Created by Rahul Meena on 14/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import MessageUI

class UserSettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var settingSections: [SettingSections] = [.premium, .account, .alerts, .support, .authentication]
    
    var settingItems: [SettingSections: [SettingItem]] {
        get {
            var allSettingItems: [SettingSections:[SettingItem]] = [:]
            
            
            if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
                
                for settingSection in settingSections {
                    var section: [SettingItem] = []
                    if settingSection == .premium {
                        if user.userTypeEnum() == .Premium {
                            section.append(SettingItem(title: "TVist Premium Member", type: .premiumSetting, action: UniversalScreenManagerAction.openTVistPremiumView, subTitle: "Manage Subscription"))
                            
                        } else {
                            section.append(SettingItem(title: "TVist Premium", type: .premiumSetting, action: UniversalScreenManagerAction.openTVistPremiumView, subTitle: "Get Premium"))
                        }
                        
                    }
                    
                    if settingSection == .account {
                        
                        section.append(SettingItem(title: "Edit Profile", type: .regular, action: .openProfileEditView, subTitle: nil, isEnabled: user.userTypeEnum() != .Guest))
                        section.append(SettingItem(title: "Time Zone", type: .regular, action: .openTimeZoneSelectionView))
                        
                    }
                    
                    if settingSection == .alerts {
                        
                        section.append(SettingItem(title: "Enable Alerts", type: .onOffSetting, action: nil))
                        section.append(SettingItem(title: "Alert Options", type: .regular, action: .openAlertOptionsView, subTitle: nil, isEnabled: (UserPreferenceVader.shared.getAlertPreference() && user.userTypeEnum() != .Guest)))
                        
                    }
                    
                    if settingSection == .support {
                        
                        section.append(SettingItem(title: "Send Feedback", type: .regular, action: nil))
                        section.append(SettingItem(title: "Help & Support", type: .regular, action: .openHelpAndSupportView, subTitle: nil, isEnabled: user.userTypeEnum() == .Premium))
                    }
                    
                    if settingSection == .authentication {
                        if user.userTypeEnum() == .Guest {
                            section.append(SettingItem(title: "Login", type: .authButton, action: .openLoginView))
                            section.append(SettingItem(title: "Sign Up", type: .authButton, action: .openSignUpView))
                        } else {
                            if !user.isPremium() {
                                section.append(SettingItem(title: "Restore Purchases", type: .authButton, action: .restorePurchasesView))
                            }
                            section.append(SettingItem(title: "Log Out", type: .authButton, action: .logOutUser))
                        }
                        
                        var loggedInMessage: String = "Logged in as "
                        
                        if user.userTypeEnum() == .Guest {
                            loggedInMessage = loggedInMessage+"Guest"
                        } else if user.userTypeEnum() == .Premium {
                            loggedInMessage = loggedInMessage+"TVist Premium User: \(user.firstName) \(user.lastName)"
                        } else if user.userTypeEnum() == .Registered {
                            loggedInMessage = loggedInMessage+"TVist Free User: \(user.firstName) \(user.lastName)"
                        }
                        
                        section.append(SettingItem(title: loggedInMessage, type: .message, action: nil))
                        
                    }
                    
                    allSettingItems[settingSection] = section
                    
                }
                
            }
            
            return allSettingItems
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.styleGuideBackgroundColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.reloadData()
    }
    

    @IBAction func didTapOnDoneButton(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func settingItemsAtSection(_ section: Int) -> [SettingItem] {
        let itemAtSection = settingSections[section]
        
        if let settingItem = settingItems[itemAtSection] {
            return settingItem
        }
        
        return []
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
    
}

extension UserSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItemsAtSection(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settingItemsAtSection(indexPath.section)[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierForCellType(type: item.type), for: indexPath) as! SettingsBaseTableViewCell
        cell.settingItem = item
        
        if indexPath.row == settingItemsAtSection(indexPath.section).count-1 {
            cell.makeBottomLineFull()
        }
        
        cell.enabledState(isEnabled: item.isEnabled)
        
        if let switchCell = cell as? SettingsOnOffTableViewCell {
            
            if item.title == "Enable Alerts" {
             
                switchCell.onOffSwitchDelegate = self
                if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
                 
                    if user.isPremium() {
                        switchCell.onOffSwitch.isOn = UserPreferenceVader.shared.getAlertPreference()
                    } else {
                        switchCell.onOffSwitch.isOn = false
                    }
                }
            }
        }
        cell.upperLine.isHidden = indexPath.row != 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settingItemsAtSection(indexPath.section)[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        AnalyticsVader.sharedVader.basicEvents(eventName: .UserSettingsItemTap, properties: ["Item Name": item.title])
        
        if let action = item.associatedAction {
            if action == .restorePurchasesView {
                IAPVader.sharedVader.delegate = self
                IAPVader.sharedVader.restorePuchases()
                
                return
            }
            ScreenVader.sharedVader.performUniversalScreenManagerAction(action, queryParams: nil)
        } else {
            if item.title == "Send Feedback" {
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.setToRecipients(["support@tvistapp.com"])
                mailComposer.setSubject("I care - Feedback on TVist app")
                if let infoDict = Bundle.main.infoDictionary, let versionString = infoDict["CFBundleShortVersionString"] as? String {
                    mailComposer.setMessageBody("I am using TVist iOS App, version \(versionString).", isHTML: false)
                }
                
                self.present(mailComposer, animated: true, completion: nil)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if settingSections[section] == .account && settingSections[section] == .alerts {
            return settingSections[section].rawValue
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = settingItemsAtSection(indexPath.section)[indexPath.row]
        
        if item.type == SettingItemType.premiumSetting {
            return 70
        }
        
        return 54
    }
}

extension UserSettingsViewController: SettingsOnOffSwitchProtocol {
    func onOffSwitchValueDidChange(isOn: Bool) {
        
        AnalyticsVader.sharedVader.basicEvents(eventName: .UserSettingsAlertPreferenceSwitch, properties: ["state":"\(isOn)"])
        
        if UserDataProvider.sharedDataProvider.premiumOnlyFeature(feature: .airtimeAlerts) {
            
            UserDataProvider.sharedDataProvider.setPreferenceFor(key: .alertPreference, value: true)
        }
        
        self.tableView.reloadData()
    }
}

extension UserSettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension UserSettingsViewController: IAPDataProtocol {
    func verificationSuccesfulForPayment(shouldDismiss: Bool) {
        self.tableView.reloadData()
    }
    
    func didFetchAvailableProducts() {
        
    }
    
    func cancelled() {
        
    }
}
