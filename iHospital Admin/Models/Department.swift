//
//  Department.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation
import SwiftUI

struct Department: Decodable {
    let id: UUID
    let name: String
    let phoneNumber: Int?
    let hex: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone_number"
        case hex
    }
    
    // Converts hex string to Color
    var hexColor: Color {
        if let hex = hex {
            return Color(hex: "#\(hex)")
        }
        return Color.blue
    }
    
    static var sample = Department(id: UUID(), name: "Cardiology", phoneNumber: 1234567890, hex: nil)
    
    static var all: [Department]?
    
    // Fetches all departments from the database
    static func fetchAll(force: Bool = false) async throws -> [Department] {
        if !force, let all = all {
            return all
        }
        
        let departments: [Department] = try await supabase.from(SupabaseTable.departments.id).select().execute().value
        all = departments.sorted { lhs, rhs in
            if lhs.name == "General Physicians" {
                return true
            } else if rhs.name == "General Physicians" {
                return false
            } else {
                return lhs.name < rhs.name
            }
        }
        
        return all!
    }
}
