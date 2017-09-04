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
    
    var channelName: String?
    var channelIcon: String?
    var episodeString: String?
    
    
    class func createAirtime(_ data: [String: Any]) -> Airtime? {
        guard let airTime = data["airtime"] as? String, let airDate = data["airdate_string"] as? String else { return nil }
        
        let airtimeObj = Airtime()
        
        airtimeObj.airTime = airTime
        airtimeObj.airDate = airDate
        airtimeObj.channelIcon = data["channel_icon"] as? String
        airtimeObj.channelName = data["channel_name"] as? String
        
        airtimeObj.episodeString = data["episode_string"] as? String
        
        return airtimeObj
    }
    
    func dayText() -> String {
        var dayText:String = ""
        if let airDate = self.airDate {
            
            if TimeUtility.getCurrentFormattedDay() == airDate {
                dayText = "Today"
            } else {
                
                let index = airDate.index(airDate.startIndex, offsetBy: 3)
                let subStr = airDate.substring(to: index)
                
                dayText += subStr
            }
        }
        
        return dayText
    }
    
    func displayString() -> String {
        var displayStr:String = ""
        if let episodeString = self.episodeString {
            displayStr += episodeString + " "
        }
        
        if let airDate = self.airDate {
            let index = airDate.index(airDate.startIndex, offsetBy: 3)
            let subStr = airDate.substring(to: index)
            displayStr += subStr+", "+self.airTime
        }
        
        return displayStr
    }

}
