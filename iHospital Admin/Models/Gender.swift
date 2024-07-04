//
//  Gender.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male = "male"
    case female = "female"
    case other = "other"
    
    var id: String {
        self.rawValue
    }
}
