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
        //return UIColor.colorWithHexString("#43C5B8")
        return UIColor.colorWithHexString("#322332")
        
    }
    class func themeColorRed() -> UIColor{
        //return UIColor.colorWithHexString("#F56363")
        return UIColor.colorWithHexString("#fe5e3a")
    }
    class func fbThemeColor() -> UIColor{
        return UIColor.colorWithHexString("#4267B2")
    }
    class func viewSelectedColor() -> UIColor{
        return UIColor.colorWithHexString("#EFEFF4")
    }
    class func textColor() -> UIColor{
        return UIColor.colorWithHexString("#353847")
    }
    class func textBlackColor() -> UIColor{
        return UIColor.colorWithHexString("#333333")
    }
    class func textGrayColor() -> UIColor{
        return UIColor.colorWithHexString("#555555")
    }
    class func textLightGrayColor() -> UIColor{
        return UIColor.colorWithHexString("#AAAAAA")
    }
    
    class func colorForMovie() -> UIColor{
        return UIColor.colorWithHexString("#551A8B")
    }
    class func colorForTvShow() -> UIColor{
        return UIColor.colorWithHexString("#FF4500")
    }
    class func colorForBook() -> UIColor{
        return UIColor.colorWithHexString("#A62A2A")
    }
    class func colorForPeople() -> UIColor{
        return UIColor.colorWithHexString("#0000ff")
    }
    
    class func placeholderColor() -> UIColor{
        return UIColor.colorWithHexString("#f2f2f2")
    }
    
    class func darkPlaceholderColor() -> UIColor{
        return UIColor.colorWithHexString("#dcdcdc")
    }
    
    
    
}

