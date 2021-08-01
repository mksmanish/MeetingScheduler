//
//  Utility.swift
//  MeetingScheduler
//
//  Created by manish on 31/07/21.
//

import Foundation
/// This class having all the common functionalities used in the project
class Utility {
    
    static let sharedInstance = Utility()
    // function to convert 24 to 12 hrs format
    func convert24hrs12(input:String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        let date24 = dateFormatter.date(from: input)!
        
        dateFormatter.dateFormat = "h:mm a"
        let date12 = dateFormatter.string(from: date24)
        return date12
        
    }

    // function to convert the input string to another string in the format of "dd-MM-yyyy"
    func convertslashtohypanformat(input:String)->String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MM/yyyy"
        let date24 = dateFormatter.date(from: input)!
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date12 = dateFormatter.string(from: date24)
        return date12
        
    }
    // function to convert the string format date to date
    func stringtosortingdate(input:String)->Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: input)
        return date
    }
    
    // function used for geeting the next day
    func nextday(currentDate:Date) -> Date {
        let date = currentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEE" // "EE" to get short style
        let dayInWeek = dateFormatter.string(from: date) // "Sunday"
        if dayInWeek == "Sat" {
          return  NSCalendar.current.date(byAdding: .day, value: 2, to: currentDate)!
        }else {
          return  NSCalendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
    // function used for geeting the previous day
    func previousday(currentDate:Date) -> Date {
        let date = currentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEE" // "EE" to get short style
        let dayInWeek = dateFormatter.string(from: date) // "Mon"
        if dayInWeek == "Mon" {
            return NSCalendar.current.date(byAdding: .day, value: -2, to: currentDate)!
        }else {
            return NSCalendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        }
    }
    // function to string to dateformat
    func stringtoDate(input:String)-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: input)
        return date
    }
    // function to dateformat to string
    func datetostring(input:Date) ->String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let myString = formatter.string(from: input)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "d/MM/yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
        
    }
    
}
