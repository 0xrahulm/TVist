//
//  CustomLoadingTableViewCell.swift
//  Escape
//
//  Created by Rahul Meena on 12/02/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class CustomLoadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
}
