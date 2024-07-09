//
//  Date.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 08/07/24.
//

import Foundation


extension Date {
    var yearsSince: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    
    var age: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0
        
        if years > 0 {
            return "\(years) years"
        } else if months > 0 {
            return "\(months) months"
        } else {
            return "\(days) days"
        }
    }
    
    var yearsOfexperience : String {
        let years = Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
        return years == 0 ? "Recently joined" : "\(years) years"
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self.startOfDay)!
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    static var RANGE_MIN_24_YEARS_OLD: PartialRangeThrough<Date> {...Calendar.current.date(byAdding: .year, value: -24, to: Date())!}
    static var RANGE_MAX_60_YEARS_AGO: ClosedRange<Date> {Calendar.current.date(byAdding: .year, value: -60, to: Date())!...Date()}
}
