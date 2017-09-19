//
//  StyleGuideSegmentControl.swift
//  TVist
//
//  Created by Rahul Meena on 13/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class StyleGuideSegmentControl: WBSegmentControl {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.style = .cover
        self.cover_range = .segment
        
        self.segmentForegroundColorSelected = UIColor.styleGuideMainTextColor()
        self.segmentForegroundColor = UIColor.styleGuideBodyTextColor()
        self.cover_color = UIColor.styleGuideBackgroundColor2()
        self.cover_opacity = 1
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.styleGuideInputColor()
        self.separatorWidth = 2
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
