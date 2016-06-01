//
//  CustomListCollectionViewCell.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ratingImage: UIImageView!
    
    var dataItems : EscapeDataItems? {
        didSet{
            if let dataItems = dataItems{
                titleLabel.text = dataItems.name
                itemImage.downloadImageWithUrl(dataItems.image , placeHolder: UIImage(named: "movie_placeholder"))
                if let year = dataItems.year{
                    yearLabel.text = year
                    yearLabel.hidden = false
                }else{
                    yearLabel.hidden = true
                }
                if let escapeRating = dataItems.escapeRating{
                    if escapeRating != 0{
                        ratingLabel.text = (String(format: "%.1f", Double(escapeRating)))
                        ratingImage.hidden = false
                        ratingLabel.hidden = false
                    }else{
                        ratingLabel.hidden = true
                        ratingImage.hidden = true
                    }
                    
                }else{
                    ratingLabel.hidden = true
                    ratingImage.hidden = true
                }
                
            }
        }
    }
    
}
