//
//  DiscoverNowViewMyAccountTableViewCell.swift
//  Escape
//
//  Created by Rahul Meena on 19/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

protocol DiscoverNowAskFriendsProtocol: class {
    func didTapiMessage()
    func didTapWhatsapp()
    func didTapMessanger()
}

class DiscoverNowViewMyAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var message:UILabel!
    
    weak var tapDelegate: DiscoverNowAskFriendsProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapOnDiscover(sender: UIButton) {
//        AnalyticsVader.sharedVader.basicEvents(eventName: .emptyStateDiscoverClick)
        ScreenVader.sharedVader.performScreenManagerAction(.TopChartsTab, queryParams: nil)
    }
    
    @IBAction func didTapOnFindAndAdd(sender: UIButton) {
//        AnalyticsVader.sharedVader.basicEvents(eventName: .emptyStateSearchClick)
        ScreenVader.sharedVader.performScreenManagerAction(.SearchTab, queryParams: nil)
    }

    
    @IBAction func imessageIconTapped(_ sender: UIButton) {
//        AnalyticsVader.sharedVader.basicEvents(eventName: .emptyStateiMessageClick)
        if let tapDelegate = tapDelegate {
            tapDelegate.didTapiMessage()
        }
    }
    
    @IBAction func whatsappIconTapped(_ sender: UIButton) {
//        AnalyticsVader.sharedVader.basicEvents(eventName: .emptyStateWhatsappClick)
        if let tapDelegate = tapDelegate {
            tapDelegate.didTapWhatsapp()
        }
    }
    
    @IBAction func messengerIconTapped(_ sender: UIButton) {
//        AnalyticsVader.sharedVader.basicEvents(eventName: .emptyStateMessengerClick)
        if let tapDelegate = tapDelegate {
            tapDelegate.didTapMessanger()
        }
    }
}
