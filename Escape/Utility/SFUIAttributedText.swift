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
    class func lightAttributedTextForString(string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: lightAttributesForSize(size, color: color))
    }
    
    class func lightAttributesForSize(size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = UIFont(name: "SFUIDisplay-Light", size: size)!
        let attributes:[String:AnyObject] = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
        
        return attributes
        
    }
    
    //SF UI Display Medium
    class func mediumAttributedTextForString(string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: mediumAttributesForSize(size, color: color))
    }
    
    class func mediumAttributesForSize(size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = UIFont(name: "SFUIDisplay-Medium", size: size)!
        let attributes:[String:AnyObject] = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
        
        return attributes
    }
    
    //SF UI Display Regular
    class func regularAttributedTextForString(string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: regularAttributesForSize(size, color: color))
    }
    
    class func regularAttributesForSize(size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = UIFont(name: "SFUIDisplay-Regular", size: size)!
        let attributes:[String:AnyObject] = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
        
        return attributes
    }
    
    //SF UI Semi-Bold
    class func semiBoldAttributedTextForString(string: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: semiBoldAttributesForSize(size, color: color))
    }
    
    class func semiBoldAttributesForSize(size: CGFloat, color: UIColor) -> Dictionary<String, AnyObject> {
        
        let font = UIFont(name: "SFUIDisplay-SemiBold", size: size)!
        let attributes:[String:AnyObject] = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
        
        return attributes
    }


}
