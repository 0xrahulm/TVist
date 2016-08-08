//
//  AddToEscapeCard.swift
//  Escape
//
//  Created by Ankit on 06/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class AddToEscapeCard: StoryCard {
    
    var items : [EscapeDataItems] = []
    
    override init(dict: [String : AnyObject]) {
        super.init(dict: dict)
        
        parseEscapeCard()
    }
    
    func parseEscapeCard(){
        
        if let objData = self.storyData{
            for data in objData{
                if let dataDict = data as? [String:AnyObject]{
                    self.items.append(EscapeDataItems(dict: dataDict))
                    
                }
            }
        }
    }

}
