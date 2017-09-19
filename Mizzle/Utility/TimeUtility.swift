//
//  TimeUtility.swift
//  Escape
//
//  Created by Ankit on 22/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class TimeUtility: NSObject {
    
    class func getTimeZoneForUser() -> TimeZoneIdentifier {
        let localTimeZoneAbbreviation: String = TimeZone.current.abbreviation() ?? ""
        let isDaylightSavingTime: Bool = TimeZone.current.isDaylightSavingTime(for: Date())
        
        if isDaylightSavingTime{
            if localTimeZoneAbbreviation == "GMT-5" {
                return .CentralTimeZone
            }
            
            if localTimeZoneAbbreviation == "GMT-6" {
                return .MountainTimeZone
            }
            
            if localTimeZoneAbbreviation == "GMT-7" {
                return .PacificTimeZone
            }
        } else {
            
            if localTimeZoneAbbreviation == "GMT-6" {
                return .CentralTimeZone
            }
            
            if localTimeZoneAbbreviation == "GMT-7" {
                return .MountainTimeZone
            }
            
            if localTimeZoneAbbreviation == "GMT-8" {
                return .PacificTimeZone
            }
        }
        
        return .EasternTimeZone
    }
    
    class func getYear(_ unixTimeStamp : Double) -> Int {
        
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        if let year = components.year {
            return year
        }
        
        return 0
        
        
    }
    class func getMonth(_ unixTimeStamp : Double) -> Int {
        
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        if let month = components.month {
            return month
        }
       
        return 0
        
    }
    class func getDay(_ unixTimeStamp : Double) -> Int {
        
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        if let day = components.day {
            return day
        }
       
        return 0
        
    }
    
    class func getComponent(_ unixTimeStamp : Double) -> DateComponents {
        
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        
        return components
        
    }
    class func getTimeStampForCard(_ unixTimeStamp : Double) -> String{
        
        let timeString = "Just now"
        
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        
        let days = Date().daysFrom(date)
        let month = Date().monthsFrom(date)
        let year = Date().yearsFrom(date)
        
        let hour = Date().hoursFrom(date)
        let min = Date().minutesFrom(date)
        
        
        if year > 1{
            return "\(year) year ago"
        }
        if year == 1{
            return "a year ago"
        }
        if month > 1{
            return "\(month) months ago"
        }
        if month == 1{
            return "a month ago"
        }
        if days > 1{
            return "\(days) days ago"
        }
        if days > 0{
            return "Yesterday"
        }
        if hour > 1{
            return "\(hour) hours"
        }
        if min > 1{
            return "\(min) mins"
        }
        
        return timeString
    }

    class func getCurrentFormattedDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEE, dd MMM"
        return dateFormatter.string(from: date)
    }
    
    class func dayFromShortDay(day: String) -> String {
        switch day {
        case "Wed":
            return "Wednesday"
        case "Tue":
            return "Tuesday"
        case "Thu":
            return "Thursday"
        case "Sat":
            return "Saturday"
        default:
            return "\(day)day"
        }
    }

}

extension Date {
    func yearsFrom(_ date: Date) -> Int {
        if let yearsFrom = (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year {
            return yearsFrom
        }
        return 0
    }
    func monthsFrom(_ date: Date) -> Int {
        if let monthsFrom = (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month {
            return monthsFrom
        }
        return 0
    }
    func weeksFrom(_ date: Date) -> Int {
        if let weekOfYear = (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear {
            return weekOfYear
        }
        return 0
    }
    func daysFrom(_ date: Date) -> Int {
        if let daysFrom = (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day {
            return daysFrom
        }
        return 0
    }
    func hoursFrom(_ date: Date) -> Int {
        if let hoursFrom = (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour {
            return hoursFrom
        }
        return 0
    }
    func minutesFrom(_ date: Date) -> Int{
        if let minutesFrom = (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute {
            return minutesFrom
        }
        return 0
    }
    func secondsFrom(_ date: Date) -> Int{
        if let secondsFrom = (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second {
            return secondsFrom
        }
        return 0
    }
    func offsetFrom(_ date: Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
