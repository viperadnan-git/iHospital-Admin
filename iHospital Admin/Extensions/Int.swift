//
//  Int.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 10/07/24.
//

import Foundation

extension Int {
    // Converts the integer to a string
    var string: String {
        String(self)
    }
    
    // Formats the integer as a currency string using a specified currency code
    var currency: String {
        self.formatted(.currency(code: Constants.currencyCode))
    }
}
