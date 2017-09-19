//
//  ProfilePictureTableViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 19/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ProfilePictureTableViewCell: SettingsBaseTableViewCell {

    @IBOutlet weak var profilePictureView: UIImageView!

    override func setupSettingsCell(settingItem: SettingItem) {
        super.setupSettingsCell(settingItem: settingItem)
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            self.profilePictureView.downloadImageWithUrl(user.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
