//
//  CommentTableViewCell.swift
//  Escape
//
//  Created by Ankit on 19/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var creatorImage: UIImageView!

    @IBOutlet weak var creatorName: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var data : StoryComment?{
        didSet{
            if let data = data, let creator = data.creator{
                creatorImage.downloadImageWithUrl(creator.image , placeHolder: UIImage(named: "profile_placeholder"))
                
                if let name = creator.name{
                    creatorName.text = name
                }else{
                    creatorName.text = ""
                }
                
                if let comment = data.comment{
                    commentLabel.text = comment
                }else{
                    commentLabel.text = ""
                }
            }
        }
    }
}
