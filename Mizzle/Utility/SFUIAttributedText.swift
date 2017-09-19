//
//  SFUIAttributedText.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class SFUIAttributedText: NSObject {
    
    //SF UI Display Light
    class func lightAttributedTextForString(_ string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: lightAttributesForSize(size, color: color))
    }
    
    class func lightAttributesForSize(_ size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
        let attributes:[String:AnyObject] = [NSAttributedStringKey.foregroundColor.rawValue: color, NSAttributedStringKey.font.rawValue: font]
        
        return attributes
        
    }
    
    //SF UI Display Medium
    class func mediumAttributedTextForString(_ string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: mediumAttributesForSize(size, color: color))
    }
    
    class func getMediumFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    class func mediumAttributesForSize(_ size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = getMediumFont(size: size)
        let attributes:[String:AnyObject] = [NSAttributedStringKey.foregroundColor.rawValue: color, NSAttributedStringKey.font.rawValue: font]
        
        return attributes
    }
    
    //SF UI Display Regular
    
    
    class func getRegularFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    class func regularAttributedTextForString(_ string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: regularAttributesForSize(size, color: color))
    }
    
    class func regularAttributesForSize(_ size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = getRegularFont(size: size)
        let attributes:[String:AnyObject] = [NSAttributedStringKey.foregroundColor.rawValue: color, NSAttributedStringKey.font.rawValue: font]
        
        return attributes
    }
    
    //SF UI Semi-Bold
    class func semiBoldAttributedTextForString(_ string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: semiBoldAttributesForSize(size, color: color))
    }
    
    class func semiBoldAttributesForSize(_ size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
        let attributes:[String:AnyObject] = [NSAttributedStringKey.foregroundColor.rawValue: color, NSAttributedStringKey.font.rawValue: font]
        
        return attributes
    }
    
    
    //SF UI Bold
    class func boldAttributedTextForString(_ string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: boldAttributesForSize(size, color: color))
    }
    
    class func boldAttributesForSize(_ size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        let attributes:[String:AnyObject] = [NSAttributedStringKey.foregroundColor.rawValue: color, NSAttributedStringKey.font.rawValue: font]
        
        return attributes
    }


}
