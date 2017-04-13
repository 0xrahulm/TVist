//
//  NotificationItem.swift
//  Escape
//
//  Created by Ankit on 02/01/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class NotificationItem: NSObject {
    
    var body :      String?
    var deepLink :  String?
    var timestamp:  NSNumber?
    
    var items : [NotificationItem] = []
    
    init(data: [[String:AnyObject]]) {
        super.init()
        parseData(data)
    }
    init(body: String?,deepLink :  String?, timestamp:  NSNumber?) {
        self.body = body
        self.deepLink = deepLink
        self.timestamp = timestamp
    }
    
    func parseData(_ data: [[String:AnyObject]]) {
        for dict in data{
            if let body = dict["body"] as? String{
                self.items.append(NotificationItem(body: body, deepLink : dict["deeplink"] as? String , timestamp : dict["time"] as? NSNumber))
            }
        }
    }

}
