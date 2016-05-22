//
//  TimeUtility.swift
//  Escape
//
//  Created by Ankit on 22/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class TimeUtility: NSObject {
    
    class func getYear(unixTimeStamp : Double) -> Int {
        
        let date = NSDate(timeIntervalSince1970: unixTimeStamp)
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        return components.year
        
        
    }
    class func getMonth(unixTimeStamp : Double) -> Int {
        
        let date = NSDate(timeIntervalSince1970: unixTimeStamp)
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
       
        return components.month
        
    }
    class func getDay(unixTimeStamp : Double) -> Int {
        
        let date = NSDate(timeIntervalSince1970: unixTimeStamp)
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
       
        return components.day
        
    }
    
    class func getComponent(unixTimeStamp : Double) -> NSDateComponents {
        
        let date = NSDate(timeIntervalSince1970: unixTimeStamp)
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        
        return components
        
    }
    

}
