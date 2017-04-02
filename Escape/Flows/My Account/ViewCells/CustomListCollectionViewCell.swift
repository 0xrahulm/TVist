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
                    yearLabel.isHidden = false
                }else{
                    yearLabel.isHidden = true
                }
                let rating = dataItems.rating
                if rating.characters.count > 0 {
                    
                    ratingLabel.text = rating
                    
                    ratingLabel.isHidden = false
                    
                }else{
                    ratingLabel.isHidden = true
                }
                
            }
        }
    }
    
    
    func popTheImage() {
        
        UIView.animate(withDuration: 0.07,
                                   animations: {
                                    self.itemImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.07, animations: {
                                        self.itemImage.transform = CGAffineTransform.identity
                                    })
        })
    }
    
}
