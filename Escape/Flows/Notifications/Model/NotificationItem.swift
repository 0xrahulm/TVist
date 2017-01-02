//
//  NotificationItem.swift
//  Escape
//
//  Created by Ankit on 02/01/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class NotificationItem: NSObject {
    
    var text :      String?
    var deepLink :  String?
    var timestamp:  NSNumber?
    
    var items : [NotificationItem] = []
    
    init(data: [[String:AnyObject]]) {
        super.init()
        parseData(data)
    }
    init(text : String?,deepLink :  String?, timestamp:  NSNumber?) {
        self.text = text
        self.deepLink = deepLink
        self.timestamp = timestamp
    }
    
    func parseData(data: [[String:AnyObject]]) {
        for dict in data{
            if let text = dict["text"] as? String{
                self.items.append(NotificationItem(text : text, deepLink : dict["deeplink"] as? String , timestamp : dict["time"] as? NSNumber))
            }
        }
    }

}
