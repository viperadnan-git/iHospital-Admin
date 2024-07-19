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
    let firstName: String
    let lastName: String
    var email: String {
        didSet {
            email = email.lowercased()
        }
    }
    let phoneNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
    }
    
    // Sample user for testing or previews
    static let sample: User = User(id: UUID(), firstName: "John", lastName: "Doe", email: "mail@viperadnan.com", phoneNumber: 1234567890)
}
