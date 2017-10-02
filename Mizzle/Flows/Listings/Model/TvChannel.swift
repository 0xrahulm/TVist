//
//  TvChannel.swift
//  Mizzle
//
//  Created by Rahul Meena on 27/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class TvChannel: NSObject {
    
    var id: String?
    var name: String?
    var callSign: String?
    var imageUrl: String?
    var number: String?
    
    class func createTvChannel(data:[String:Any]) -> TvChannel? {
        guard let id = data["id"] as? String, let callSign = data["call_sign"] as? String else { return nil }
        
        let tvChannel = TvChannel()
        tvChannel.id = id
        tvChannel.callSign = callSign
        tvChannel.name = callSign
        if let channelName = data["name"] as? String {
            tvChannel.name = channelName
        }
        tvChannel.imageUrl = data["img_url"] as? String
        tvChannel.number = data["channel_number"] as? String
        
        return tvChannel
    }
}
