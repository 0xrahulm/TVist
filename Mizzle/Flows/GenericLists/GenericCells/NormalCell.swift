//
//  GenericCell.swift
//  Escape
//
//  Created by Rahul Meena on 29/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class NormalCell: UITableViewCell {

    @IBOutlet weak var hairLineHeightConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let hairLineHeightConstraint = hairLineHeightConstraint {
            hairLineHeightConstraint.constant = 0.5
        }
    }
    
}
