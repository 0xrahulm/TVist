//
//  EscapeCollectionViewCell.swift
//  Escape
//
//  Created by Ankit on 06/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class EscapeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var escapeImage: UIImageView!
    @IBOutlet weak var escapeTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var seperatorLabel: UILabel!
    @IBOutlet weak var directorTypeLabel: UILabel!
    
    
    var data : EscapeDataItems?{
        didSet{
            if let data  = data{
                
                if let image = data.image{
                    escapeImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "movie_placeholder"))
                }else{
                    escapeImage.image =  UIImage(named: "movie_placeholder")
                }
                
                if let title = data.name{
                    escapeTitleLabel.text = title
                }else{
                    escapeTitleLabel.text = ""
                }
                
                if let year = data.year{
                    yearLabel.text = year
                    seperatorLabel.isHidden = false
                }else{
                    yearLabel.text  = "|"
                    seperatorLabel.isHidden = true
                }
                
                if let rating = data.escapeRating{
                    ratingLabel.text = "\(rating)"
                }else{
                    ratingLabel.text = ""
                }
                var directedByStr = ""
                if let type =  data.escapeType{
                    if type == .Movie{
                        directedByStr = "Director:"
                    }else if type == .TvShows{
                        directedByStr = "Creator:"
                    }else{
                        directedByStr = "Author:"
                    }
                }
                var directorByStr = ""
                if let director = data.creator{
                    directorByStr = director
                }
                
                let directedByString = SFUIAttributedText.regularAttributedTextForString("\(directedByStr)  ", size: 14, color: UIColor.textGrayColor())
                
                let directorString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(directorByStr)", size: 14, color: UIColor.textBlackColor()))
                
                let attributedString = NSMutableAttributedString()
                attributedString.append(directedByString)
                attributedString.append(directorString)
                directorTypeLabel.attributedText = attributedString
                
            }
            
            self.outerView.layer.borderWidth = 1
            self.outerView.layer.borderColor = UIColor.placeholderColor().cgColor
            self.outerView.layer.cornerRadius = 5
        }
    }
    
    
    
}
