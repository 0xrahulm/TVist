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
    @IBOutlet weak var mediaYearLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var alertIconImageView: UIImageView!
    
    var mediaItem: EscapeItem? {
        didSet {
            if let mediaItem = self.mediaItem {
                setupCell(mediaItem: mediaItem)
            }
        }
    }
    
    func setupCell(mediaItem: EscapeItem) {
        
        self.mediaTitleLabel.text = mediaItem.name
        self.mediaYearLabel.text = mediaItem.year
        self.posterImageView.downloadImageWithUrl(mediaItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
        
        alertIconImageView.isHidden = !mediaItem.isTracking
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
