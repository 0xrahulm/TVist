//
//  GenreItemTableViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 31/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GenreItemTableViewCell: UITableViewCell {

    
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
    
    
}
