//
//  MedicalRecord.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

struct MedicalRecord: Codable {
    var id: Int
    var note: String
    var imagePath: String
    var medicines: [String]
    var appointment: Appointment
    
    enum CodingKeys: String, CodingKey {
        case id
        case note
        case imagePath = "image_path"
        case medicines
        case appointment
    }
    
    static let supabaseSelectQuery = "*, appointment:appointment_id(\(Appointment.supabaseSelectQuery))"
    
    static func new(note:String, image: Data, medicines:[Medicine], appointment: Appointment) async throws -> MedicalRecord {
        let imagePath = try await appointment.saveImage(fileName: UUID().uuidString, data: image)
        
        let medicinesString = "{" + medicines.map { $0.text }.joined(separator: ", ") + "}"
        
        let response: MedicalRecord = try await supabase.from(SupabaseTable.medicalRecords.id)
            .insert([
                "note": note,
                "image_path": imagePath,
                "medicines": medicinesString,
                "appointment_id": appointment.id.string
            ])
            .select(supabaseSelectQuery)
            .single()
            .execute()
            .value

        return response
    }
}
