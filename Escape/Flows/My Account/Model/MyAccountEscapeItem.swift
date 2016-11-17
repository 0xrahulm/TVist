//
//  MyAccountEscapeItem.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class MyAccountEscapeItem: NSObject {
    
    var title : String?
    var count : NSNumber?
    var escapeData : [EscapeDataItems]?
    
    init(title : String?, count: NSNumber?, escapeData: [EscapeDataItems]?) {
        self.title = title
        self.count = count
        self.escapeData = escapeData
    }
    
    

}
