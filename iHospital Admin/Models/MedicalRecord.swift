//
//  MedicalRecord.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

struct MedicalRecord: Codable, Identifiable {
    var id: Int
    var note: String
    var imagePath: String
    var medicines: [String]
    var appointment: Appointment
    var patient: Patient
    
    enum CodingKeys: String, CodingKey {
        case id
        case note
        case imagePath = "image_path"
        case medicines
        case appointment
        case patient
    }
    
    static let supabaseSelectQuery = "*, appointment:appointment_id(\(Appointment.supabaseSelectQuery)), patient:patient_id(*)"
    
    static let sample = MedicalRecord(id: 1, note: "Patient has a fever", imagePath: "https://supabase.io/storage/v1/object/public/medical-records/1.jpg,https://supabase.io/storage/v1/object/public/medical-records/2.jpg", medicines: ["AZ Medicine", "AB Medicine"], appointment: Appointment.sample, patient: Patient.sample)
    
    func loadImage() async throws -> Data {
        try await supabase.storage.from(SupabaseBucket.medicalRecords.id).download(path: imagePath)
    }
    
    static func new(note:String, image: Data, medicines:[Medicine], labTests:[Int], appointment: Appointment) async throws {
        let imagePath = try await appointment.saveImage(fileName: UUID().uuidString, data: image)
        
        let medicinesString = "{" + medicines.map { $0.text }.joined(separator: ", ") + "}"
        
        try await supabase.from(SupabaseTable.medicalRecords.id)
            .insert([
                "note": note,
                "image_path": imagePath,
                "medicines": medicinesString,
                "appointment_id": appointment.id.string,
                "patient_id": appointment.patient.id.uuidString
            ])
            .select(supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        
        if !labTests.isEmpty {
            let labTestParsed = labTests.map { item in
                [
                    "test_id": item.string,
                    "status": LabTestStatus.pending.rawValue,
                    "patient_id": appointment.patient.id.uuidString,
                    "appointment_id": appointment.id.string
                ]
            }

            try await supabase.from(SupabaseTable.labTests.id)
                .insert(labTestParsed)
                .select(LabTest.supabaseSelectQuery)
                .execute()
        }
    }
}
