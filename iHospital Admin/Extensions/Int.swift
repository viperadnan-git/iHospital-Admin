//
//  Int.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 10/07/24.
//

import Foundation

extension Int {
    var string: String {
        String(self)
    }
    
    var currency: String {
        self.formatted(.currency(code: Constants.currencyCode))
    }
}
