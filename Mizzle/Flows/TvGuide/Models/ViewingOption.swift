//
//  ViewingOption.swift
//  Mizzle
//
//  Created by Rahul Meena on 05/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

enum ViewingOptionType:String {
    case Stream = "stream"
    case Buy = "buy"
    case Rent = "rent"
    case Air = "air"
    case Ticket = "ticket"
}

class ViewingOption: NSObject {
    
    var text: String?
    var type: ViewingOptionType?
    var link: String?
    
    class func parseViewingOptionData(data: [String:Any]) -> ViewingOption? {
        guard let type = data["type"] as? String else {
            return nil
        }
        let viewingOption = ViewingOption()
        
        viewingOption.text = data["text"] as? String
        viewingOption.link = data["link"] as? String
        
        if let viewOptionType = ViewingOptionType(rawValue: type) {
            viewingOption.type = viewOptionType
        }
        
        return viewingOption
    }
}
