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
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self.startOfDay)!
    }
    
    static var RANGE_MIN_24_YEARS_OLD: PartialRangeThrough<Date> {...Calendar.current.date(byAdding: .year, value: -24, to: Date())!}
    static var RANGE_MAX_60_YEARS_AGO: ClosedRange<Date> {Calendar.current.date(byAdding: .year, value: -60, to: Date())!...Date()}
}
