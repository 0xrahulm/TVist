//
//  IconsUtility.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class IconsUtility: NSObject {
    
    class func airtimeIcon() -> UIImage {
        return IonIcons.image(withIcon: ion_ios_monitor, size: kDefaultIconSize, color: UIColor.buttonGrayColor())
    }

}
