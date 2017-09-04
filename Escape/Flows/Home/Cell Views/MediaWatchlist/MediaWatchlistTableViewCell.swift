//
//  MediaWatchlistTableViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 25/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class MediaWatchlistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaTitleLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var channelImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
