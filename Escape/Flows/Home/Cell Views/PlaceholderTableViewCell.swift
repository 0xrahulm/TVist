//
//  PlaceholderTableViewCell.swift
//  Escape
//
//  Created by Ankit on 08/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Shimmer

class PlaceholderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagePlaceholderView: FBShimmeringView!
    
    @IBOutlet weak var imageOuterView: UIView!

    @IBOutlet weak var placeholderView: FBShimmeringView!

    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var placeHolder2View: FBShimmeringView!
    
    @IBOutlet weak var placeHolder2OuterView: UIView!
    
    
    
    func shimmer(){
        placeholderView.contentView = outerView
        placeholderView.shimmering = true
        
        imagePlaceholderView.contentView = imageOuterView
        imagePlaceholderView.shimmering = true
        
        placeHolder2View.contentView = placeHolder2OuterView
        placeHolder2View.shimmering = true
    }
    
    
}
