//
//  MediaWatchlistTableViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 25/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol MediaWatchlistCellProtocol: class {
    func didTapOnSwipeDetection(cell: UITableViewCell)
}

class MediaWatchlistTableViewCell: SwipeTableViewCell {
    
    weak var mediaWatchlistDelegate: MediaWatchlistCellProtocol?
    
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaYearLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var alertIconImageView: UIImageView!
    
    @IBOutlet weak var alertIconWidthConstraint: NSLayoutConstraint!
    
    var isSeenCell: Bool = false
    
    
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
        
        if isSeenCell {
            alertIconWidthConstraint.constant = 0
        } else {
            alertIconWidthConstraint.constant = 12
            
            if mediaItem.isAlertSet {
                alertIconImageView.image = UIImage(named: "AlertIcon")
            } else {
                alertIconImageView.image = UIImage(named: "AlertIconGray")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func didTapOnSwipeDetails() {
        if let delegate = mediaWatchlistDelegate {
            delegate.didTapOnSwipeDetection(cell: self)
        }
    }
}
