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
    
    var hexColor: Color {
        if let hex = hex {
            // TODO: Custom hex color
            return Color.accentColor
        }
        return Color.accentColor
    }
    
    static var sample = Department(id: UUID(), name: "Cardiology", phoneNumber: 1234567890, hex: nil)
    
    static var all: [Department]?
    
    static func fetchAll() async throws -> [Department] {
        if let all = all {
            return all
        }
        
        let departments: [Department] = try await supabase.from(SupabaseTable.departments.id).select().execute().value
        all = departments
        return departments
    }
}
