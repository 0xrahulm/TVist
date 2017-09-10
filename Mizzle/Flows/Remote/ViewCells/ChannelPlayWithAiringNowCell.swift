//
//  ChannelPlayWithAiringNowCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 30/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ChannelPlayWithAiringNowCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    
    @IBOutlet weak var channelIcon: UIImageView!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var channelNumberLabel: UILabel!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var mediaItem: ListingMediaItem? {
        didSet{
            if let dataItems = mediaItem {
                titleLabel.text = dataItems.constructedTitle()
                itemImage.downloadImageWithUrl(dataItems.mediaItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
                
                
                if ctaButton != nil {
                    
                    ctaButton.setImage(IonIcons.image(withIcon: ion_ios_play, size: 18, color: UIColor.defaultTintColor()), for: .normal)
                    ctaButton.setImage(IonIcons.image(withIcon: ion_ios_play, size: 18, color: UIColor.defaultTintColor()), for: .selected)
                }
                
                self.endTimeLabel.text = dataItems.endtimeString
                
                if let iconImage = dataItems.channelItem?.icon {
                    
                    self.channelIcon.downloadImageWithUrl(iconImage, placeHolder: IconsUtility.airtimeIcon())
                }
                
                if let finishPercentage = dataItems.finishPercentage {
                    self.progressView.tintColor = UIColor.defaultTintColor()
                    self.progressView.setProgress(Float(finishPercentage), animated: false)
                }
                
                
                if let channelItem = dataItems.channelItem {
                    self.channelIcon.downloadImageWithUrl(channelItem.icon, placeHolder: IconsUtility.airtimeIcon())
                    self.channelNameLabel.text = channelItem.name
                    self.channelNumberLabel.text = channelItem.number
                }
                
            }
        }
    }
    
}
