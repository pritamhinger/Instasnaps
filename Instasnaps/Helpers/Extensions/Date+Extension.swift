//
//  Date+Extension.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 17/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import Foundation

extension Date{
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        var quotient = 0;
        var unit = ""
        
        if(secondsAgo < minute){
            quotient = secondsAgo
            unit = "second"
        }
        else if(secondsAgo < hour){
            quotient = secondsAgo/minute
            unit = "minute"
        }
        else if (secondsAgo < day){
            quotient = secondsAgo/hour
            unit = "hour"
        }
        else if (secondsAgo < week){
            quotient = secondsAgo/day
            unit = "day"
        }
        else if(secondsAgo < month){
            quotient = secondsAgo/week
            unit = "week"
        }
        else{
            quotient = secondsAgo/month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
}
