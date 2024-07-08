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
}
