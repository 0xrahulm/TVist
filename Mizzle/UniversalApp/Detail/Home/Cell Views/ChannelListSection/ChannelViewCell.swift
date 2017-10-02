//
//  ChannelViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 27/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ChannelViewCell: UICollectionViewCell {
    
    @IBOutlet weak var channelImageView:UIImageView!

    var tvChannel: TvChannel? {
        didSet {
            if let tvChannel = self.tvChannel {
                self.channelImageView.downloadImageWithUrl(tvChannel.imageUrl, placeHolder: IconsUtility.airtimeIcon())
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func popTheImage() {
        
        UIView.animate(withDuration: 0.07,
                       animations: {
                        self.channelImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { finish in
                        UIView.animate(withDuration: 0.07, animations: {
                            self.channelImageView.transform = CGAffineTransform.identity
                        })
        })
    }
}
