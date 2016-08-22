//
//  PlaceholderView.swift
//  Escape`
//
//  Created by Ankit on 08/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class PlaceholderView: FBShimmeringView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetUp()
        
    }
    
    func xibSetUp(){
        
        self.backgroundColor = UIColor.darkPlaceholderColor()
        
        let outerView = UIView(frame: self.frame)
        outerView.backgroundColor = UIColor.placeholderColor()
        self.contentView = outerView
        self.shimmering = true
        
    }
  
}
