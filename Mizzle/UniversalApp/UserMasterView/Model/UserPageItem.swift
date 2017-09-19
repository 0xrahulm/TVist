//
//  UserPageItem.swift
//  TVist
//
//  Created by Rahul Meena on 12/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UserPageItem: NSObject {
    
    var itemName: String!
    var itemImage: String!
    var defaultAction: UniversalScreenManagerAction!
    var queryParams: [String:Any]?
    
    init(name: String, image: String, action: UniversalScreenManagerAction, queryParams: [String:Any]?) {
        super.init()
        
        self.itemName = name
        self.itemImage = image
        self.defaultAction = action
        self.queryParams = queryParams
    }
    
}
