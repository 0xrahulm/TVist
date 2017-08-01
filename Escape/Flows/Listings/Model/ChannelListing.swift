//
//  NSObject.swift
//  Mizzle
//
//  Created by Rahul Meena on 27/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ChannelListing: NSObject {
    
    var channel: TvChannel!
    var programListings: [ListingMediaItem] = []

    
    class func parseChannelListing(_ data: [String:Any]) -> ChannelListing? {
        
        guard let network = data["network"] as? [String: Any], let channel = TvChannel.createTvChannel(data: network), let programListings:[[String: Any]] = data["program_listings"] as? [[String: Any]] else { return nil }
        
        
        let channelListing = ChannelListing()
        
        channelListing.channel = channel
        
        for programListing in programListings {
            if let programListItem = ListingMediaItem.parseListingMediaItem(programListing) {
                channelListing.programListings.append(programListItem)
            }
        }
        
        return channelListing
    }
}
