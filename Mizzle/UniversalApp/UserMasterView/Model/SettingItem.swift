//
//  SettingItem.swift
//  TVist
//
//  Created by Rahul Meena on 14/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SettingItem: NSObject {
    
    var title: String!
    var subTitle: String?
    
    var imageAsset: String?
    
    var type: SettingItemType!
    
    var associatedAction: UniversalScreenManagerAction?
    
    var isEnabled: Bool = true
    
    
    init(title: String, type: SettingItemType, action: UniversalScreenManagerAction?, subTitle: String? = nil, isEnabled: Bool = true, imageAsset: String? = nil) {
        super.init()
        
        self.title = title
        self.type = type
        self.subTitle = subTitle
        self.imageAsset = imageAsset
        self.associatedAction = action
        self.isEnabled = isEnabled
        
    }
}
