//
//  ListingMediaDetailsCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingMediaDetailsCell: NormalCell {
    
    @IBOutlet weak var airtimeLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    
    
    var showFullDate: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellForListingMediaItem(listingMediaItem: ListingMediaItem) {
        
        if showFullDate {
            if let airDate = listingMediaItem.airdate {
                let index = airDate.index(airDate.startIndex, offsetBy: 3)
                let subStr = airDate.substring(to:index)
                    
                self.airtimeLabel.text =  subStr+", "+listingMediaItem.airtime
                
            } else {
                
                self.airtimeLabel.text = listingMediaItem.airtime
            }
        } else {
            
            self.airtimeLabel.text = listingMediaItem.airtime
        }
        
        
        self.showNameLabel.text = listingMediaItem.constructedTitle()
        self.castLabel.text = listingMediaItem.mediaItem.cast
        
        self.posterImageView.downloadImageWithUrl(listingMediaItem.mediaItem.posterImage, placeHolder: nil)
        
        if let rating = listingMediaItem.mediaItem.rating {
            
            if rating.characters.count > 0 {
                ratingLabel.text = rating
                
                ratingLabel.isHidden = false
                ratingView.isHidden = false
                
            }else{
                ratingLabel.isHidden = true
                ratingView.isHidden = true
            }
        }
    }
    
}
