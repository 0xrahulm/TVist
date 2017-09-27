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
    
    @IBOutlet weak var alertCountView: UIView!
    @IBOutlet weak var alertCountLabel: UILabel!
    @IBOutlet weak var mainCountView: UIView!
    @IBOutlet weak var mainCountLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    var userPageItem: UserPageItem? {
        didSet {
            if let pageItem = self.userPageItem {
                itemName.text = pageItem.itemName
                itemImageView.image = UIImage(named: pageItem.itemImage)
                
                if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
                    
                    if pageItem.defaultAction! == UniversalScreenManagerAction.watchlistDetailView {
                        self.mainCountView.isHidden = false
                        self.mainCountLabel.text = "\(user.escape_count)"
                        
                        self.alertCountView.isHidden = false
                        self.alertCountLabel.text = "\(user.alerts_count)"
                    } else {
                        self.mainCountView.isHidden = true
                        self.alertCountView.isHidden = true
                    }
                    
                    if pageItem.defaultAction! == .seenDetailView {
                        
                        self.mainCountView.isHidden = false
                        self.mainCountLabel.text = "\(user.seen_count)"
                    } else if pageItem.defaultAction! != UniversalScreenManagerAction.watchlistDetailView {
                        self.mainCountView.isHidden = true
                    }
                    
                }
                
            }
        }
    }
    
    func makeBottomLineFull() {
        self.bottomLineLeadingConstraint.constant = 0
        self.bottomLineTrailingConstraint.constant = 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if animated {
            
            UIView.animate(withDuration: ViewConstants.defaultAnimationDuration) {
                if selected {
                    self.bottomView.backgroundColor = UIColor.styleGuideActionButtonBlue()
                } else {
                    self.bottomView.backgroundColor = UIColor.styleGuideLineGrayLight()
                }
            }
            
        } else {
            
            if selected {
                self.bottomView.backgroundColor = UIColor.styleGuideActionButtonBlue()
            } else {
                self.bottomView.backgroundColor = UIColor.styleGuideLineGrayLight()
            }
        }
    }

}
