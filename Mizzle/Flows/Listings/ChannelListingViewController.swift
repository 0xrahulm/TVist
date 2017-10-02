//
//  ChannelListingViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ChannelListingViewController: GenericAllItemsListViewController {
    
    
    
    var startDate: String!
    var endDate: String?
    var isToday: Bool = false
    var channel: TvChannel!
    
    var titlesForSection: [String] = []
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let tvChannel = queryParams["channel"] as? TvChannel {
            self.channel = tvChannel
        }
        
        if let listingItem = queryParams["listingItem"] as? ChannelListing {
            
        }
        
        if let startTime = queryParams["startDate"] as? String {
            self.startDate = startTime
        }
        
        if let endDate = queryParams["endDate"] as? String {
            self.endDate = endDate
        }
        
        if let isToday = queryParams["isToday"] as? Bool {
            self.isToday = isToday
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let channelName = self.channel.name {
            
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.ChannelListingPageOpened, properties: ["ChannelName": channelName])
            
            self.title = channelName
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelListingViewController.receivedData(notification:)), name: Notification.Name(rawValue:NotificationObservers.ListingMediaItemsObserver.rawValue), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func itemTapEvent(itemName: String, index: Int) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .ChannelListingItemClick, properties: ["ItemName":itemName, "Position": "\(index+1)"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func fetchRequest() {
        
        ListingsDataProvider.shared.fetchListingsForChannel(channel: self.channel, startTime: self.startDate, endTime: self.endDate, page: self.nextPage, isToday: isToday)
    }
    
    @objc func receivedData(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let listData = userInfo["data"] as? [EscapeItem], let channelId = userInfo["channel_id"] as? String {
                if let currentChannelId = self.channel.id, channelId == currentChannelId {
                    appendDataToBeListed(appendableData: listData, page: userInfo["page"] as? Int)
                }
                
            }
        }
    }
    
}
