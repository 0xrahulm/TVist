//
//  DiscoverEscapeTableViewCell.swift
//  Escape
//
//  Created by Ankit on 01/06/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class DiscoverEscapeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var directorLabel: UILabel!
    
    @IBOutlet weak var ctaButton: UIButton!
    
    @IBOutlet weak var distinguishView: UIView!
    
    var data : DiscoverItems? {
        didSet{
            if let data = data{
                titleLabel.text = data.name
                posterImage.downloadImageWithUrl(data.image , placeHolder: UIImage(named: "movie_placeholder"))
                if let director = data.director{
                    directorLabel.text = director
                    directorLabel.hidden = false
                }else{
                    directorLabel.hidden = true
                }
                if data.discoverType == .Movie{
                    distinguishView.backgroundColor = UIColor.colorForMovie()
                }else if data.discoverType == .Books{
                    distinguishView.backgroundColor = UIColor.colorForBook()
                }else if data.discoverType == .TvShows{
                    distinguishView.backgroundColor = UIColor.colorForTvShow()
                }else if data.discoverType == .People{
                    distinguishView.backgroundColor = UIColor.colorForPeople()
                }
                
            }
            
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
