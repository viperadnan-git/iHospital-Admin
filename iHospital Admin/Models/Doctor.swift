//
//  Doctor.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation

struct Doctor: Codable {
    var id: UUID
    var name: String
    var dateOfBirth : Date
    var gender: Gender
    var phoneNumber: String
    var email: String
    var qualification: String
    var experience: Date
}
