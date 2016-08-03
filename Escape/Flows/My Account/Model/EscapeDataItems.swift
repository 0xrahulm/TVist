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
    var year : String?
    var escapeRating : NSNumber?
    var escapeType : EscapeType?
    
    init(id : String?,name : String?,image : String?,escapeType : EscapeType?,escapeRating : NSNumber?,  year : String?) {
        self.id = id
        self.name = name
        self.image = image
        self.escapeType = escapeType
        self.escapeRating = escapeRating
        self.year = year
    }

}
