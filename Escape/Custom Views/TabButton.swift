//
//  TabButton.swift
//  Escape
//
//  Created by Rahul Meena on 14/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class TabButton: UIButton {
    
    var selectionIndicator: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectionIndicator = UIView(frame: CGRect(x: 0, y: bounds.height-1.5, width: bounds.width, height: 1.5))
        
        selectionIndicator.backgroundColor = UIColor.escapeBlueColor()
        selectionIndicator.hidden = true
        
        self.addSubview(selectionIndicator)
    }
    
    func setTabTitle(title: String) {
        setAttributedTitle(SFUIAttributedText.semiBoldAttributedTextForString(title, size: 15, color: UIColor.textGrayColor()), forState: .Normal)
        setAttributedTitle(SFUIAttributedText.semiBoldAttributedTextForString(title, size: 15, color: UIColor.themeColorBlack()), forState: .Selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonEnabled(enabled: Bool) {
        self.selected = enabled
        selectionIndicator.hidden = !enabled
    }
}
