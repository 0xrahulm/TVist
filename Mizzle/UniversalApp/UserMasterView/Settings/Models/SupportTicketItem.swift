//
//  SupportTicketItem.swift
//  TVist
//
//  Created by Rahul Meena on 20/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SupportTicketItem: NSObject {

    
    var id: String!
    var title: String!
    var simpleId: String?
    var supportType: SupportTicketType = .technical
    var body: String?
    var isOpen:Bool = true
    
    class func parseSupportTicketData(_ data: [String:Any]) -> SupportTicketItem? {
        guard let name = data["title"] as? String, let id = data["id"] as? String else { return nil }
        
        let ticketItem = SupportTicketItem()
        
        ticketItem.id = id
        ticketItem.title = name
        ticketItem.simpleId = data["simple_id"] as? String
        ticketItem.body = data["body"] as? String
        
        if let ticketTypeVal = data["support_type"] as? Int, let ticketType = SupportTicketType(rawValue: ticketTypeVal) {
            ticketItem.supportType = ticketType
        }
        
        if let isOpen = data["is_open"] as? Bool {
            ticketItem.isOpen = isOpen
        }
        
        return ticketItem
    }
}
