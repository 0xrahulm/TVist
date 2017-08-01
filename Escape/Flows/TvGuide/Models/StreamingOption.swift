//
//  StreamingOption.swift
//  Mizzle
//
//  Created by Rahul Meena on 23/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class StreamingOption: NSObject {
    
//    
//    "id": "6960813b-0ab5-4538-8d4a-64974c6e6ad3",
//    "name": "Netflix",
//    "description": "Free* 14 days trial",
//    "image": "https://www.mizzleapp.com/images/netflix.png",
//    "link": "https://www.netflix.com",
//    "order": 0
    
    
    var name: String?
    var desc: String?
    var image: String?
    var link: String?
    var id: String!
    var title: String?
    
    class func parseStreamingOptionData(data: [String:Any]) -> StreamingOption? {
        
        guard let streamingName = data["name"] as? String else {
            return nil
        }
        
        let streamingOption = StreamingOption()
        
        streamingOption.name = streamingName
        if let streamingId = data["id"] as? String {
            streamingOption.id = streamingId
        }
        
        streamingOption.image = data["image"] as? String
        streamingOption.desc = data["description"] as? String
        streamingOption.link = data["link"] as? String
        streamingOption.title = data["title"] as? String
        
        return streamingOption
    }
    
}
