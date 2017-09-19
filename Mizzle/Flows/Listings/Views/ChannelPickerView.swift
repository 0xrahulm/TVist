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
    var updateOnce:Bool = false
    
    let kButtonHeight:CGFloat = 55.0
    
    func setChannelItems(channelItems: [TvChannel], defaultSelected: Int) {
        if self.bubbleView != nil {
            self.bubbleView.removeFromSuperview()
            buttons.removeAll()
            
            underlines.removeAll()
        }
        self.channelItems = channelItems
        setupBubbleViewControl()
        updateOnce = false
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
                button.downloadImageWithUrl(imageUrl, placeHolder: IconsUtility.airtimeIcon())
            } else {
                button.setImage(IconsUtility.airtimeIcon(), for: .normal)
            }
            button.sizeToFit()
            let buttonWidth:CGFloat = 105
            
            
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: kButtonHeight)
            
            button.clipsToBounds = true
            button.tag = buttonTag
            
            
            buttonTag += 1
            button.addTarget(self, action: #selector(ChannelPickerView.bubbleTapped(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 4
            let underline = UIView(frame: CGRect(x: currentX, y: currentY+kButtonHeight+3, width: buttonWidth, height: 1.5))
                
            
            currentX += 7+buttonWidth
            
            
            bubbleView.addSubview(button)
            bubbleView.addSubview(underline)
            
            buttons.append(button)
            underlines.append(underline)
        }
        bubbleView.contentSize = CGSize(width: currentX, height: 50)
        addSubview(bubbleView)
        
    }
    
    @objc func bubbleTapped(_ sender: UIButton) {
        
        
        setSelected(index: sender.tag)
        
    }
    
    func setSelected(index: Int) {
        
        for button in buttons {
            if (button.tag == index) {
                button.alpha = 1.0
                button.setSelected(selected: true)
            } else {
                button.alpha = 0.5
                button.setSelected(selected: false)
            }
        }
        
        if channelPickerDelegate != nil {
            
            if channelItems.count > index {
                let channel = channelItems[index]
                if updateOnce {
                    if let channelName = channel.name {
//                        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.ListingsPickChannel, properties: ["ChannelName": channelName, "Position": "\(index+1)"])
                    }
                }
                updateOnce = true
                channelPickerDelegate?.didTapOnChannel(channel)
            }
            
        }
        
        setLineViewColor(selectedIndex: index)
    }
    
    
    
    func setLineViewColor(selectedIndex: Int) {
        
        for (index,lineView) in underlines.enumerated() {
            
            if index == selectedIndex {
                lineView.backgroundColor = UIColor.defaultTintColor()
            } else {
                lineView.backgroundColor = UIColor.hairlineGrayColor()
            }
        }
        
    }

}
