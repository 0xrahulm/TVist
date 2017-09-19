//
//  CategoryPickerView.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol CategoryPickerProtocol: class {
    func didTapOnItemAtIndex(_ index: Int)
}


class CategoryPickerView: UIView {
    
    var categoryItems: [ListingCategory] = []
    weak var categoryPickerDelegate: CategoryPickerProtocol?
    
    var buttons: [UIButton] = []
    
    
    func setCategoryItems(categoryItems: [ListingCategory], defaultSelected: Int) {
        
        self.categoryItems = categoryItems
        setupBubbleViewControl()
        
        setSelected(index: defaultSelected)
    }
    
    func setupBubbleViewControl() {
        let bubbleView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        bubbleView.showsVerticalScrollIndicator = false
        bubbleView.showsHorizontalScrollIndicator = false
        
        var currentX: CGFloat = 10
        let currentY: CGFloat = 5
        var buttonTag = 0
        
        
        
        for categoryItem in categoryItems {
            let button = UIButton(type: .custom)
            if let categoryName = categoryItem.name {
                
                button.setAttributedTitle(SFUIAttributedText.mediumAttributedTextForString(categoryName, size: 15, color: UIColor.white), for: .normal)
                button.setAttributedTitle(SFUIAttributedText.mediumAttributedTextForString(categoryName, size: 15, color: UIColor.white), for: .selected)
            }
            
            button.sizeToFit()
            let buttonWidth = button.frame.width + 35
                
            button.setBackgroundImage(UIImage.getImageWithColor(UIColor.defaultTintColor(), size: CGSize(width: 1, height: 1)), for: .selected)
            button.setBackgroundImage(UIImage.getImageWithColor(UIColor.buttonGrayColor(), size: CGSize(width: 1, height: 1)), for: .normal)
            
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: 40)
            
            button.clipsToBounds = true
            button.tag = buttonTag

            buttonTag += 1
            button.addTarget(self, action: #selector(CategoryPickerView.bubbleTapped(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 4
            
            
            currentX += 10+buttonWidth
            
            bubbleView.addSubview(button)
            buttons.append(button)
        }
        bubbleView.contentSize = CGSize(width: currentX, height: 50)
        addSubview(bubbleView)
        
    }
    
    @objc func bubbleTapped(_ sender: UIButton) {
        
        setSelected(index: sender.tag)
        
    }
    
    func setSelected(index: Int) {
        
        for button in buttons {
            button.isSelected = (button.tag == index)
        }
        
        if categoryPickerDelegate != nil {
            
            categoryPickerDelegate?.didTapOnItemAtIndex(index)
        }
    }
}
