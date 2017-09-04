//
//  MediaRemotePlayViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol MediaRemotePlayProtocol: class {
    func didTapOnChannelNumber(channelNumber: String)
}

class MediaRemotePlayViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var channelIcon: UIImageView!
    
    @IBOutlet weak var ctaButton: UIButton!
    
    @IBOutlet weak var endTimeLabel: UILabel!

    @IBOutlet weak var progressView: UIProgressView!

    weak var mediaRemoteDelegate: MediaRemotePlayProtocol?

    var mediaItem : ListingMediaItem? {
        didSet{
            if let dataItems = mediaItem {
                titleLabel.text = dataItems.constructedTitle()
                itemImage.downloadImageWithUrl(dataItems.mediaItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
                
                
                if ctaButton != nil {
                    
                    ctaButton.setImage(IonIcons.image(withIcon: ion_monitor, size: 18, color: UIColor.defaultTintColor()), for: .normal)
//                    ctaButton.setImage(IonIcons.image(withIcon: ion_monitor, size: 18, color: UIColor.defaultTintColor()), for: .selected)
                }
                
                self.endTimeLabel.text = dataItems.endtimeString
                
                if let iconImage = dataItems.channelItem?.icon {
                    
                    self.channelIcon.downloadImageWithUrl(iconImage, placeHolder: IconsUtility.airtimeIcon())
                }
                
                if let finishPercentage = dataItems.finishPercentage {
                    self.progressView.tintColor = UIColor.defaultTintColor()
                    self.progressView.setProgress(Float(finishPercentage), animated: false)
                }
                
                
            }
        }
    }
    
    @IBAction func didTapOnChannelChange(sender: UIButton) {
        
        if let mediaItem = self.mediaItem, let channelNumber = mediaItem.channelItem?.number {
            if let escapeName = mediaItem.mediaItem.name, let channelName = mediaItem.channelItem?.name {
                AnalyticsVader.sharedVader.basicEvents(eventName: .HomeAiringNowPlayClick, properties: ["escapeName": escapeName, "channelName": channelName])
            }
            if let mediaRemoteDelegate = self.mediaRemoteDelegate {
                mediaRemoteDelegate.didTapOnChannelNumber(channelNumber: channelNumber)
            }
        }
    }
}
