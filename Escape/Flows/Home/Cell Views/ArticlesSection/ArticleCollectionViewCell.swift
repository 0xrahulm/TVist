//
//  ArticleCollectionViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 29/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var articleItem: ArticleItem? {
        didSet{
            if let dataItem = articleItem {
                
                self.titleLabel.text = dataItem.title
                self.itemImage.downloadImageWithUrl(dataItem.image, placeHolder: nil)
                self.descriptionLabel.text = dataItem.desc
            }
        }
    }
    

}
