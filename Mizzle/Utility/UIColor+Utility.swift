//
//  UIColor+Utility.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
extension UIColor{
    
    class func colorWithHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count) != 6 {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    class func defaultTintColor() -> UIColor {
        return UIColor.colorWithHexString("#FF3F00")
    }
    
    class func defaultCTAColor() -> UIColor {
        return UIColor.colorWithHexString("#2C3E50")
    }
    
    class func mizzleBlueColor() -> UIColor{
        return UIColor.colorWithHexString("#0067DF")
    }
    
    class func themeColorBlack() -> UIColor {
        return UIColor.colorWithHexString("#142e34")
    }
    
    class func escapeRedColor() -> UIColor{
        return UIColor.colorWithHexString("#F3244B")
    }
    
    class func mizzleBlackColor() -> UIColor {
        return UIColor.colorWithHexString("#2C3E50")
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
    class func buttonGrayColor() -> UIColor{
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
    
    class func styleGuideLineGray() -> UIColor {
        return UIColor.colorWithHexString("#C2C4CA")
    }
    
    class func styleGuideLineGrayLight() -> UIColor {
        return UIColor.colorWithHexString("#D7D8DA")
    }
    
    class func styleGuideButtonRed() -> UIColor {
        return UIColor.colorWithHexString("#FF5A00")
    }
    
    class func styleGuidePremiumOrange() -> UIColor {
        return UIColor.colorWithHexString("#FF9500")
    }
    
    class func styleGuideTableViewSeparator() -> UIColor {
        return UIColor.colorWithHexString("#E0E0E0")
    }
    
    class func styleGuideBackgroundColor() -> UIColor {
        return UIColor.colorWithHexString("#FAFAFA")
    }
    
    class func styleGuideMainTextColor() -> UIColor {
        return UIColor.black
    }
    
    class func styleGuideBodyTextColor() -> UIColor {
        return UIColor.colorWithHexString("#8C8C8C")
    }
    
    class func styleGuideBackgroundColor2() -> UIColor {
        return UIColor.white
    }
    
    @objc class func styleGuideInputColor() -> UIColor {
        return UIColor.colorWithHexString("#EFEFF3")
    }
    
    class func styleGuideIconsColor() -> UIColor {
        return UIColor.colorWithHexString("#CDCED2")
    }
    
    class func styleGuideActionButtonBlue() -> UIColor {
        return UIColor.colorWithHexString("#007AFF")
    }
    
    class func styleGuideActionGreen() -> UIColor {
        return UIColor.colorWithHexString("#21D439")
    }
    
    class func styleGuideActionRed() -> UIColor {
        return UIColor.colorWithHexString("#FF3B30")
    }
}

