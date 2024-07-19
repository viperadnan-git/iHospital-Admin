//
//  LabTestType.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

class LabTestType: Codable, Identifiable {
    let id: Int
    var name: String
    var price: Int
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
    }
    
    init(id: Int, name: String, price: Int, description: String) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
    }
    
    static let supabaseSelectQuery = "*"
    
    // Sample instance for testing or previews
    static let sample = LabTestType(id: 1, name: "X-Ray", price: 100, description: "X-Ray of the chest")
    
    static var all: [LabTestType] = []
    
    // Fetches all lab test types from the database
    static func fetchAll(force: Bool = false) async throws -> [LabTestType] {
        if !force, !all.isEmpty {
            return all
        }
        
        let response: [LabTestType] = try await supabase.from(SupabaseTable.labTestTypes.id).select(supabaseSelectQuery).execute().value
        all = response
        return response
    }
    
    // Creates a new lab test type in the database
    static func new(name: String, price: Int, description: String) async throws -> LabTestType {
        let response: LabTestType = try await supabase.from(SupabaseTable.labTestTypes.id)
            .insert([
                CodingKeys.name.rawValue: name,
                CodingKeys.price.rawValue: price.string,
                CodingKeys.description.rawValue: description
            ])
            .select()
            .single()
            .execute()
            .value
        
        all.append(response)
        
        return response
    }
    
    // Saves updates to an existing lab test type in the database
    func save() async throws -> LabTestType {
        let response: LabTestType = try await supabase.from(SupabaseTable.labTestTypes.id)
            .update([
                CodingKeys.name.rawValue: name,
                CodingKeys.price.rawValue: price.string,
                CodingKeys.description.rawValue: description
            ])
            .eq(CodingKeys.id.rawValue, value: id)
            .select()
            .single()
            .execute()
            .value
        
        if let index = LabTestType.all.firstIndex(where: { $0.id == id }) {
            LabTestType.all[index] = response
        }
        
        return response
    }
    
    // Deletes a lab test type from the database
    func delete() async throws {
        try await supabase.from(SupabaseTable.labTestTypes.id)
            .delete()
            .eq(CodingKeys.id.rawValue, value: id)
            .execute()
        
        if let index = LabTestType.all.firstIndex(where: { $0.id == id }) {
            LabTestType.all.remove(at: index)
        }
    }
}
