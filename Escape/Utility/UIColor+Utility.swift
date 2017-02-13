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
    
    class func escapeBlueColor() -> UIColor{
        return UIColor.colorWithHexString("#0DD6CA")
    }
    
    class func themeColorBlack() -> UIColor {
        return UIColor.colorWithHexString("#142e34")
    }
    
    class func escapeRedColor() -> UIColor{
        return UIColor.colorWithHexString("#F3244B")
    }
    
    class func escapeGray() -> UIColor {
        return UIColor.colorWithHexString("#f7f7f7")
    }
    
    class func hairlineGrayColor() -> UIColor {
        return UIColor.colorWithHexString("#ebebeb")
    }
    
    class func lineGrayColor() -> UIColor {
        return UIColor.colorWithHexString("#C8CBD3")
    }

    class func fbThemeColor() -> UIColor{
        return UIColor.colorWithHexString("#3664a2")
    }
    
    class func textColor() -> UIColor{
        return UIColor.colorWithHexString("#353847")
    }
    class func textBlackColor() -> UIColor{
        return UIColor.colorWithHexString("#142E34")
    }
    class func textGrayColor() -> UIColor{
        return UIColor.colorWithHexString("#98A4AF")
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
    
    class func searchBarPlaceHolderColor() -> UIColor{
        return UIColor.colorWithHexString("#EEEEEE")
    }
    
    class func searchBarLightGreyBackgroundColor() -> UIColor{
        return UIColor.colorWithHexString("#E8E7E7")
    }
    
    class func facebookThemeColor() -> UIColor{
        return UIColor.colorWithHexString("#3b5998")
    }
    
}

