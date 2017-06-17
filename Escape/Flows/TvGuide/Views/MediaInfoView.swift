//
//  MediaInfoView.swift
//  Mizzle
//
//  Created by Rahul Meena on 16/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class MediaInfoView: UIView {

    
        @IBOutlet weak var similarEscapesView: SimilarEscapesView!
        @IBOutlet weak var relatedPeopleView: RelatedPeopleView!
        @IBOutlet weak var runTimeLabel:    UILabel!
        @IBOutlet weak var creatorTypeLabel: UILabel!
    
        @IBOutlet weak var creatorLabel: UILabel!
        @IBOutlet weak var castLabel: UILabel!
        @IBOutlet weak var castDetailLabel: UILabel!
        @IBOutlet weak var descriptionLabel: UILabel!
    
        @IBOutlet weak var runTimeImage: UIImageView!
        
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
