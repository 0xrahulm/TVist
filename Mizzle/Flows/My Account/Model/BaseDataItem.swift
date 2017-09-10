//
//  BaseDataItem.swift
//  Escape
//
//  Created by Rahul Meena on 14/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class BaseDataItem: NSObject {
    
    var id : String?
    var name : String?
    
    init(id: String?, name: String?) {
        super.init()
        
        self.id = id
        self.name = name
        
    }
    
    override init() {
        super.init()
    }
    
}
