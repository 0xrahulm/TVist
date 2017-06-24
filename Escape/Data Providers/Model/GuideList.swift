//
//  GuideList.swift
//  Mizzle
//
//  Created by Rahul Meena on 13/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GuideList: NSObject {
    var type: GuideListType?
    var data: [GuideItem] = []
    var userId: String?
    
    
    func parseData(_ guideItemsData:[[String:AnyObject]]) {
        for eachItem in guideItemsData {
            
            if let guideItem = GuideItem.createGuideItem(itemData: eachItem) {

                data.append(guideItem)
            }
        }
        
    }
}
