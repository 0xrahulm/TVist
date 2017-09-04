//
//  GenreCollectionViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 29/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!

    
    
    var genreItem: GenreItem? {
        didSet{
            if let dataItem = genreItem {
                
                self.titleLabel.text = dataItem.name
                self.itemImage.downloadImageWithUrl(dataItem.displayImage, placeHolder: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
