//
//  ChannelPickerView.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol ChannelPickerProtocol: class {
    func didTapOnChannel(_ channel: TvChannel)
}

class ChannelPickerView: UIView {

    
    var channelItems: [TvChannel] = []
    weak var channelPickerDelegate: ChannelPickerProtocol?
    
    var buttons: [ChannelButton] = []
    var underlines: [UIView] = []
    
    var bubbleView:UIScrollView!
    
    
    let kButtonHeight:CGFloat = 55.0
    
    func setChannelItems(channelItems: [TvChannel], defaultSelected: Int) {
        if self.bubbleView != nil {
            self.bubbleView.removeFromSuperview()
            buttons.removeAll()
            underlines.removeAll()
        }
        self.channelItems = channelItems
        setupBubbleViewControl()
        
        setSelected(index: defaultSelected)
    }
    
    func setupBubbleViewControl() {
        bubbleView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 65))
        bubbleView.showsVerticalScrollIndicator = false
        bubbleView.showsHorizontalScrollIndicator = false
        
        var currentX: CGFloat = 10
        let currentY: CGFloat = 5
        var buttonTag = 0
        
        
        
        for channelItem in channelItems {
            let button = ChannelButton(type: .custom)
            if let imageUrl = channelItem.imageUrl {
                button.downloadImageWithUrl(imageUrl, placeHolder: IonIcons.image(withIcon: ion_ios_monitor, size: kDefaultIconSize, color: UIColor.buttonGrayColor()))
            } else {
                button.setImage(IonIcons.image(withIcon: ion_ios_monitor, size: kDefaultIconSize, color: UIColor.buttonGrayColor()), for: .normal)
            }
            button.sizeToFit()
            let buttonWidth:CGFloat = 100
            
            
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: kButtonHeight)
            
            button.clipsToBounds = true
            button.tag = buttonTag
            
            
            buttonTag += 1
            button.addTarget(self, action: #selector(ChannelPickerView.bubbleTapped(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 4
            let underline = UIView(frame: CGRect(x: currentX, y: currentY+kButtonHeight+3, width: buttonWidth, height: 1))
                
            
            currentX += 10+buttonWidth
            
            
            bubbleView.addSubview(button)
            bubbleView.addSubview(underline)
            
            buttons.append(button)
            underlines.append(underline)
        }
        bubbleView.contentSize = CGSize(width: currentX, height: 50)
        addSubview(bubbleView)
        
    }
    
    func bubbleTapped(_ sender: UIButton) {
        
        
        setSelected(index: sender.tag)
        
    }
    
    func setSelected(index: Int) {
        
        for button in buttons {
            button.setSelected(selected: (button.tag == index))
        }
        
        if channelPickerDelegate != nil {
            
            if channelItems.count > index {
                channelPickerDelegate?.didTapOnChannel(channelItems[index])
            }
            
        }
        
        setLineViewColor(selectedIndex: index)
    }
    
    
    
    func setLineViewColor(selectedIndex: Int) {
        
        for (index,lineView) in underlines.enumerated() {
            
            if index == selectedIndex {
                lineView.backgroundColor = UIColor.defaultCTAColor()
            } else {
                lineView.backgroundColor = UIColor.hairlineGrayColor()
            }
        }
        
    }

}
