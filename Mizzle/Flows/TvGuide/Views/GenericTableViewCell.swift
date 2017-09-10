//
//  GenericTableViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 05/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GenericTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
