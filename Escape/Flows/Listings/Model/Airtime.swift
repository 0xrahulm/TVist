//
//  Airtime.swift
//  Mizzle
//
//  Created by Rahul Meena on 01/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class Airtime: NSObject {
    
    var airDate: String?
    var airTime: String!
    var displayString: String?
    var channelName: String?
    var channelIcon: String?
    
    
    class func createAirtime(_ data: [String: Any]) -> Airtime? {
        guard let airTime = data["airtime"] as? String, let airDate = data["airdate_string"] as? String else { return nil }
        
        let airtimeObj = Airtime()
        
        airtimeObj.airTime = airTime
        airtimeObj.airDate = airDate
        airtimeObj.channelIcon = data["channel_icon"] as? String
        airtimeObj.channelName = data["channel_name"] as? String
        
        airtimeObj.displayString = data["display_string"] as? String
        
        return airtimeObj
    }

}
