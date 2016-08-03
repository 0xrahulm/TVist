//
//  InterestItems.swift
//  Escape
//
//  Created by Ankit on 24/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class InterestItems: NSObject {
    var id : NSNumber?
    var name : String?
    var weightage : Int?
    var isSelected : Bool?
    
    init(id : NSNumber?, name : String?, weightage : Int?,isSelected : Bool?) {
        
        self.id = id
        self.name = name
        self.weightage = weightage
        self.isSelected = isSelected
    }

}
