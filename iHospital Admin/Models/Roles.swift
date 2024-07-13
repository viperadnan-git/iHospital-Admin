//
//  Role.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation


enum Roles: String, Codable {
    case admin = "admin"
    case doctor = "doctor"
    case labTech = "lab_tech"
}


struct Role: Codable {
    let userId: UUID
    let role: Roles
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case role
    }
}
