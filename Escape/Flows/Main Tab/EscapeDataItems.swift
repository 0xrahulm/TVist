//
//  EscapeDataItems.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class EscapeDataItems: NSObject {
    
    var id : String?
    var name : String?
    var image : String?
    var escapeType : EscapeType?
    
    init(id : String?,name : String?,image : String?,escapeType : EscapeType?) {
        self.id = id
        self.name = name
        self.image = image
        self.escapeType = escapeType
    }

}
