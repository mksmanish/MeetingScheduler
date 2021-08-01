//
//  Constants.swift
//  MeetingScheduler
//
//  Created by manish on 31/07/21.
//

import Foundation
class Constants : NSObject {
    
    enum Indentifiers {
        static let meetingcell = "meetingcell"
        static let landscapeCell = "landscapeCell"
        static let ScheduleController = "ScheduleController"
        static let AvialbleController = "AvialbleController"
        static let availableCell = "availableCell"
    }
    
    enum Urls {
        static let ServiceUrl = "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date="
    }
    
    enum dateformats {
        static let forDate = "yyyy-mm-dd HH:mm:ss"
        static let resultDate = "MMM d, yyyy"
        static let resultTime = "hh:mm a"
    }
    
    enum rowHeight {
        static let regularRow = 92
     
    }
    
    enum message {
        static let SelectDate = "Select Date"
    }
}
