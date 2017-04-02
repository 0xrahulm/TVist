//
//  BubblePickerView.swift
//  Escape
//
//  Created by Ankit on 27/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//
import UIKit

protocol BubblePickerProtocol: class {
    func didTapOnItemAtIndex(_ sender: UIButton)
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
        let bubbleView = UIView(frame: CGRect(x: 10, y: 10, width: frame.width-20, height: 10))
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var buttonTag = 0
        
        var buttonsInRow = [UIButton]()
        
        for preferenceItem in preferenceItems {
            let button = UIButton(type: .custom)
            button.setAttributedTitle(SFUIAttributedText.mediumAttributedTextForString(preferenceItem.name!.uppercased(), size: 15, color: UIColor.white.withAlphaComponent(0.6)), for: UIControlState())
            button.setAttributedTitle(SFUIAttributedText.mediumAttributedTextForString(preferenceItem.name!.uppercased(), size: 15, color: UIColor.textBlackColor()), for: .selected)
            
            button.sizeToFit()
            let buttonWidth = button.frame.width + 35
            
            if currentX+buttonWidth > bubbleView.frame.width {
                currentY += 45
                for buttonInRow in buttonsInRow {
                    let offset = (bubbleView.frame.width - currentX)/2
                    var buttonFrame = buttonInRow.frame
                    buttonFrame.origin.x += offset
                    buttonInRow.frame = buttonFrame
                }
                currentX = 0
                buttonsInRow.removeAll()
            }
            button.setBackgroundImage(UIImage.getImageWithColor(UIColor.white, size: CGSize(width: 1, height: 1)), for: .selected)
            
            button.setImage(UIImage(named: "createFeedPlus"), for: UIControlState())
            button.setImage(UIImage(named: "createFeedTick"), for: .selected)
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, button.frame.width+15, 0, 0)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0)
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: 35)
            
            button.clipsToBounds = true
            button.layer.borderColor  = UIColor.white.withAlphaComponent(0.6).cgColor
            button.layer.borderWidth  = 1
            button.tag = buttonTag
            buttonTag += 1
            button.addTarget(self, action: #selector(BubblePickerView.bubbleTapped(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 4
            if let isSelected = preferenceItem.isSelected {
                if isSelected{
                    button.isSelected = true
                }
                
            }
            
            currentX += 10+buttonWidth
            
            buttonsInRow.append(button)
            
            bubbleView.addSubview(button)
        }
        for buttonInRow in buttonsInRow {
            let offset = (bubbleView.frame.width - currentX)/2
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
    
    func bubbleTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if bubblePickerDelegate != nil {
            bubblePickerDelegate?.didTapOnItemAtIndex(sender)
        }
       
    }
}
