//
//  EscapeCell.swift
//  Escape
//
//  Created by Rahul Meena on 29/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class EscapeCell: NormalCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var creatorTypeLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    
    @IBOutlet weak var addEditButton: UIButton!
    
    
    var escapeItem: EscapeItem? {
        didSet {
            attachData()
        }
    }
    
    func attachData() {
        
        if let escapeItem = escapeItem {
            var escapeTitleStr = escapeItem.name
            let year = escapeItem.year
            if year.characters.count > 0 && escapeItem.escapeTypeVal() != .Books {
                escapeTitleStr += " (\(year))"
            }
            titleLabel.text = escapeTitleStr
            subtitleLabel.text = escapeItem.subTitle
            
            posterImageView.downloadImageWithUrl(escapeItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
            
            if let createdBy = escapeItem.createdBy {
                creatorNameLabel.text = createdBy
                creatorNameLabel.hidden = false
            }else{
                creatorNameLabel.hidden = true
            }
            
            if escapeItem.escapeTypeVal() == .Movie{
                creatorTypeLabel.text = EscapeCreatorType.Movie.rawValue+":"
            }else if escapeItem.escapeTypeVal() == .Books{
                creatorTypeLabel.text = EscapeCreatorType.Books.rawValue+":"
            }else if escapeItem.escapeTypeVal() == .TvShows{
                creatorTypeLabel.text = EscapeCreatorType.TvShows.rawValue+":"
            }
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
