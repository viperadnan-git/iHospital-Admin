//
//  String.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 08/07/24.
//

import Foundation

extension String {
    // Checks if the string contains only alphabets and spaces
    var isAlphabetsAndSpace: Bool {
        return !isEmpty && range(of: "[^a-zA-Z ]", options: .regularExpression) == nil
    }
    
    // Checks if the string contains only alphabets
    var isAlphabets: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    // Validates if the string is a valid email address
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    // Validates if the string is a valid phone number (10 digits)
    var isPhoneNumber: Bool {
        return !isEmpty && range(of: "^[0-9]{10}$", options: .regularExpression) != nil
    }
    
    // Trims whitespace and newline characters from the string
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
