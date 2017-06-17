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
    
    @IBOutlet weak var ctaButton: UIButton!
    
    @IBOutlet weak var maxRatingLabel: UILabel!
    @IBOutlet weak var ratedImage: UIImageView!
    var dataItems : EscapeItem? {
        didSet{
            if let dataItems = dataItems{
                titleLabel.text = dataItems.name
                itemImage.downloadImageWithUrl(dataItems.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
                let year = dataItems.year
                
                if ctaButton != nil {
                    
                    ctaButton.setImage(IonIcons.image(withIcon: ion_android_time, size: 20, color: UIColor.white), for: .normal)
                    ctaButton.setImage(IonIcons.image(withIcon: ion_android_done_all, size: 20, color: UIColor.white), for: .selected)
                }
                
                
                
                if year.characters.count > 0 {

//                    yearLabel.isHidden = false
                }else{
//                    yearLabel.isHidden = true
                }
                let rating = dataItems.rating
                if rating.characters.count > 0 {
                    
                    ratingLabel.text = rating
                    
                    ratingLabel.isHidden = false
                    if maxRatingLabel != nil && ratedImage != nil{
                        maxRatingLabel.isHidden = false
                        ratedImage.isHidden = false
                    }
                   
                    
                }else{
                    ratingLabel.isHidden = true
                    if maxRatingLabel != nil && ratedImage != nil{
                        maxRatingLabel.isHidden = true
                        ratedImage.isHidden = true
                    }
                    
                    
                }
                
            }
        }
    }
    
    
    @IBAction func trackButtonTapped(sender: UIButton) {
        toggleButtonState()
    }
    
    func toggleButtonState() {
        ctaButton.popButtonAnimate()
        let newState = !ctaButton.isSelected
        ctaButton.isSelected = newState
        if newState {
            ctaButton.backgroundColor = UIColor.defaultCTAColor()
        } else {
            ctaButton.backgroundColor = UIColor.defaultTintColor()
            
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
