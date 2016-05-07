//
//  UIColor+Utility.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
extension UIColor{
    
    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count) != 6 {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    class func themeColorBlue() -> UIColor{
        return UIColor.colorWithHexString("#43C5B8")
        
    }
    class func themeColorRed() -> UIColor{
        return UIColor.colorWithHexString("#F56363")
    }
    class func fbThemeColor() -> UIColor{
        return UIColor.colorWithHexString("#4267B2")
    }
    class func textColor() -> UIColor{
        return UIColor.colorWithHexString("#353847")
    }
    class func viewSelectedColor() -> UIColor{
        return UIColor.colorWithHexString("#EFEFF4")
    }
    
    
}

