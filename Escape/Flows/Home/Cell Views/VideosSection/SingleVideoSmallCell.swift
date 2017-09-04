//
//  SingleVideoSmallCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 29/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SingleVideoSmallCell: NormalCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var videoItem: VideoItem? {
        didSet{
            if let dataItem = videoItem {
                
                self.titleLabel.text = dataItem.title
                self.thumbnailImage.downloadImageWithUrl(dataItem.thumbnail, placeHolder: nil)
                
            }
        }
    }
    
    
    
}
