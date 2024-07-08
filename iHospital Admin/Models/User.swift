//
//  User.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 08/07/24.
//

import Foundation
import Auth
import Supabase


struct User: Codable, Hashable {
    let id: UUID
    let name: String
    var email: String {
        didSet {
            email = email.lowercased()
        }
    }
    let phoneNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case email
        case phoneNumber = "phone_number"
    }
    
    var firstName: Substring {
        name.split(separator: " ").first!
    }
    
   
    static let sample: User = User(id: UUID(), name: "John Doe", email: "mail@viperadnan.com", phoneNumber: 1234567890)
}
