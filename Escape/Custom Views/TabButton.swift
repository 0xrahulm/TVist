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
    let kPaddingBetweenTitleAndImage:CGFloat = 9
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setTabTitle(title: String, type: ProfileListType) {
        setAttributedTitle(SFUIAttributedText.semiBoldAttributedTextForString(title, size: 12, color: UIColor.textGrayColor()), forState: .Normal)
        setAttributedTitle(SFUIAttributedText.semiBoldAttributedTextForString(title, size: 12, color: UIColor.escapeRedColor()), forState: .Selected)
        
        setImage(UIImage(named: type.rawValue), forState: .Normal)
        setImage(UIImage(named: type.rawValue+"_selected"), forState: .Selected)
        
        if let imageView = self.imageView, titleLabel = self.titleLabel {
            let imageSize = imageView.frame.size
            let titleSize = titleLabel.frame.size
            let totalHeight = imageSize.height+titleSize.height+kPaddingBetweenTitleAndImage
            
            self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height - 7), left: 0, bottom: 0, right: -titleSize.width)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(totalHeight-titleSize.height+8), right: 0)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: titleSize.height, right: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonEnabled(enabled: Bool) {
        self.selected = enabled
    }
}
