//
//  Department.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation


struct Department: Decodable {
    let id: UUID
    let name: String
    let phoneNumber: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone_number"
    }
    
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
