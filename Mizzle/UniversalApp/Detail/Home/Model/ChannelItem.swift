//
//  ChannelItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ChannelItem: NSObject {
    
    var name: String?
    var icon: String?
    var number: String?
    
    class func createChannelItem(data: [String:Any]) -> ChannelItem? {
        
        let channelItem = ChannelItem()
        channelItem.name = data["name"] as? String
        channelItem.icon = data["img_url"] as? String
        channelItem.number = data["channel_number"] as? String
        
        return channelItem
    }

}
