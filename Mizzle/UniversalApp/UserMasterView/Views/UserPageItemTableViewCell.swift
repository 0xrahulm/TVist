//
//  UserPageItemTableViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 12/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UserPageItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!

    @IBOutlet weak var bottomLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLineTrailingConstraint: NSLayoutConstraint!
    
    var userPageItem: UserPageItem? {
        didSet {
            if let pageItem = self.userPageItem {
                itemName.text = pageItem.itemName
                itemImageView.image = UIImage(named: pageItem.itemImage)
            }
        }
    }
    
    func makeBottomLineFull() {
        self.bottomLineLeadingConstraint.constant = 0
        self.bottomLineTrailingConstraint.constant = 0
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
