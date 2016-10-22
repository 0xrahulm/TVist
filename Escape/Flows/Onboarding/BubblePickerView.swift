//
//  BubblePickerView.swift
//  Escape
//
//  Created by Ankit on 27/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//
import UIKit

protocol BubblePickerProtocol: class {
    func didTapOnItemAtIndex(sender: UIButton)
}


class BubblePickerView: UIView {
    
    var heightOfView: CGFloat = 0
    var preferenceItems: [InterestItems] = []
    weak var bubblePickerDelegate: BubblePickerProtocol?
    
    init(frame: CGRect, preferenceItems: [InterestItems]) {
        super.init(frame: frame)
        self.preferenceItems = preferenceItems
        setupBubbleViewControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBubbleViewControl() {
        let bubbleView = UIView(frame: CGRect(x: 10, y: 10, width: CGRectGetWidth(frame)-20, height: 10))
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var buttonTag = 0
        
        var buttonsInRow = [UIButton]()
        
        for preferenceItem in preferenceItems {
            let button = UIButton(type: .Custom)
            button.setAttributedTitle(SFUIAttributedText.mediumAttributedTextForString(preferenceItem.name!.uppercaseString, size: 15, color: UIColor.whiteColor().colorWithAlphaComponent(0.6)), forState: .Normal)
            button.setAttributedTitle(SFUIAttributedText.mediumAttributedTextForString(preferenceItem.name!.uppercaseString, size: 15, color: UIColor.textBlackColor()), forState: .Selected)
            
            button.sizeToFit()
            let buttonWidth = CGRectGetWidth(button.frame) + 35
            
            if currentX+buttonWidth > CGRectGetWidth(bubbleView.frame) {
                currentY += 45
                for buttonInRow in buttonsInRow {
                    let offset = (CGRectGetWidth(bubbleView.frame) - currentX)/2
                    var buttonFrame = buttonInRow.frame
                    buttonFrame.origin.x += offset
                    buttonInRow.frame = buttonFrame
                }
                currentX = 0
                buttonsInRow.removeAll()
            }
            button.setBackgroundImage(UIImage.getImageWithColor(UIColor.whiteColor(), size: CGSizeMake(1, 1)), forState: .Selected)
            
            button.setImage(UIImage(named: "createFeedPlus"), forState: .Normal)
            button.setImage(UIImage(named: "createFeedTick"), forState: .Selected)
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(button.frame)+15, 0, 0)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0)
            button.frame = CGRectMake(currentX, currentY, buttonWidth, 35)
            
            button.clipsToBounds = true
            button.layer.borderColor  = UIColor.whiteColor().colorWithAlphaComponent(0.6).CGColor
            button.layer.borderWidth  = 1
            button.tag = buttonTag
            buttonTag += 1
            button.addTarget(self, action: #selector(BubblePickerView.bubbleTapped(_:)), forControlEvents: .TouchUpInside)
            button.layer.cornerRadius = 4
            if let isSelected = preferenceItem.isSelected {
                if isSelected{
                    button.selected = true
                }
                
            }
            
            currentX += 10+buttonWidth
            
            buttonsInRow.append(button)
            
            bubbleView.addSubview(button)
        }
        for buttonInRow in buttonsInRow {
            let offset = (CGRectGetWidth(bubbleView.frame) - currentX)/2
            var buttonFrame = buttonInRow.frame
            buttonFrame.origin.x += offset
            buttonInRow.frame = buttonFrame
        }
        buttonsInRow.removeAll()
        
        var bubbleViewFrame = bubbleView.frame
        bubbleViewFrame.size.height = (currentY + 40)
        bubbleView.frame = bubbleViewFrame
        
        addSubview(bubbleView)
        heightOfView = bubbleViewFrame.height
    }
    
    func bubbleTapped(sender: UIButton) {
        sender.selected = !sender.selected
        
        if bubblePickerDelegate != nil {
            bubblePickerDelegate?.didTapOnItemAtIndex(sender)
        }
       
    }
}
