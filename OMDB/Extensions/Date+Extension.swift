//
//  Date+Extension.swift
//  OMDB
//
//  Created by Rahul Garg on 25/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation

extension Date {
    
    var timeAgoString: String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "A year ago" : "\(year) years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "A month ago" : "\(month) months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "A day ago" : "\(day) days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "An hour ago" : "\(hour) hours ago"
        } else {
            return "a moment ago"
        }
    }
    
}
