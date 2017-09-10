//
//  OnBoardingUtility.swift
//  Escape
//
//  Created by Ankit on 23/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class OnBoardingUtility: NSObject {
    
    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPassword(_ password : String) -> Bool{
        if password.characters.count >= 6 {
            return true
        }
        return false
    }

}
