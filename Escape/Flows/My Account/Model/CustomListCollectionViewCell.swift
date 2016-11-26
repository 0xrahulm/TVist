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
    
    var dataItems : EscapeItem? {
        didSet{
            if let dataItems = dataItems{
                titleLabel.text = dataItems.name
                itemImage.downloadImageWithUrl(dataItems.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
                let year = dataItems.year
                if year.characters.count > 0 {
                    yearLabel.text = year
                    yearLabel.hidden = false
                }else{
                    yearLabel.hidden = true
                }
                let rating = dataItems.rating
                if rating.characters.count > 0 {
                    
                    ratingLabel.text = rating
                    
                    ratingLabel.hidden = false
                    
                }else{
                    ratingLabel.hidden = true
                }
                
            }
        }
    }
    
    
    func popTheImage() {
        
        UIView.animateWithDuration(0.07,
                                   animations: {
                                    self.itemImage.transform = CGAffineTransformMakeScale(0.95, 0.95)
            },
                                   completion: { finish in
                                    UIView.animateWithDuration(0.07){
                                        self.itemImage.transform = CGAffineTransformIdentity
                                    }
        })
    }
    
}
