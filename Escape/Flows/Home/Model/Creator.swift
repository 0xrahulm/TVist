//
//  Creator.swift
//  Escape
//
//  Created by Ankit on 19/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import RealmSwift

class Creator: NSObject {
    
    var id : String?
    var type : CreatorType?
    var name : String?
    var image : String?
    
    
    init(dict : [String:AnyObject]) {
        super.init()
        parseData(dict)
    }
    
    func parseData(_ dict : [String:AnyObject]){
        self.id = dict["id"] as? String
        if let type = dict["type"] as? NSNumber{
            if let creatorType = CreatorType(rawValue: type){
                self.type = creatorType
            }
        }
        self.name = dict["full_name"] as? String
        self.image = dict["profile_picture"] as? String
    }

}

