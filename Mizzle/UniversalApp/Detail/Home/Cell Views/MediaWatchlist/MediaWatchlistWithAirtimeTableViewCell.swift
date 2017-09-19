//
//  MediaWatchlistWithAirtimeTableViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 13/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class MediaWatchlistWithAirtimeTableViewCell: MediaWatchlistTableViewCell {
    
    
    @IBOutlet weak var channelImageView: UIImageView!
    
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    
    var removeYear: Bool = false
 
    override func setupCell(mediaItem: EscapeItem) {
        super.setupCell(mediaItem: mediaItem)
        
        if let nextAirtime = mediaItem.nextAirtime {
            self.dayTimeLabel.text = nextAirtime.dayText()+", "+nextAirtime.airTime
            
            if let episodeString = nextAirtime.episodeString {
                self.seasonEpisodeLabel.text = episodeString
            } else {
                self.seasonEpisodeLabel.text = nextAirtime.channelName
            }
            
            self.channelImageView.downloadImageWithUrl(nextAirtime.channelIcon, placeHolder: IconsUtility.airtimeIcon())
            
            if removeYear {
                self.mediaYearLabel.text = nil
            } 
        } else {
            self.dayTimeLabel.text = nil
            self.seasonEpisodeLabel.text = nil
            self.channelImageView.image = nil
        }
    }
}
