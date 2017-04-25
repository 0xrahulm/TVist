//
//  DiscoverNowViewMyAccountTableViewCell.swift
//  Escape
//
//  Created by Rahul Meena on 19/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class DiscoverNowViewMyAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var message:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapOnDiscover(sender: UIButton) {
        ScreenVader.sharedVader.performScreenManagerAction(.DiscoverTab, queryParams: nil)
    }
    
    @IBAction func didTapOnFindAndAdd(sender: UIButton) {
        ScreenVader.sharedVader.performScreenManagerAction(.SearchTab, queryParams: nil)
    }

}
