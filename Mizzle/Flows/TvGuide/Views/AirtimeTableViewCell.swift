//
//  AirtimeTableViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class AirtimeTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    
    @IBOutlet weak var channelImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
