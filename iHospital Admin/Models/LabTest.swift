//
//  LabTest.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

class LabTest: Codable, Identifiable {
    let id: Int
    let name: String
    let patient: Patient
    var status: LabTestStatus
    let appointment: Appointment
    var sampleID: String?
    var reportPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case patient
        case status
        case appointment
        case sampleID = "sample_id"
        case reportPath = "report_path"
    }
    
    static let supabaseSelectQuery = "*, patient:patient_id(*), appointment:appointment_id(\(Appointment.supabaseSelectQuery))"
    
    static let sample = LabTest(id: 1, name: "X-Ray", patient: Patient.sample, status: .pending, appointment: Appointment.sample, sampleID: nil, reportPath: nil)
    
    init(id: Int, name: String, patient: Patient, status: LabTestStatus, appointment: Appointment, sampleID: String?, reportPath: String?) {
        self.id = id
        self.name = name
        self.patient = patient
        self.status = status
        self.appointment = appointment
        self.sampleID = sampleID
        self.reportPath = reportPath
    }
    
    func updateSampleID(_ sampleID: String) async throws -> LabTest {
        self.sampleID = sampleID
        
        let response:LabTest = try await supabase.from(SupabaseTable.labTests.id)
            .update([CodingKeys.sampleID.rawValue: sampleID, CodingKeys.status.rawValue: LabTestStatus.inProgress.rawValue])
            .eq(CodingKeys.id.rawValue, value: self.id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    func uploadReport(_ filePath: URL) async throws -> LabTest {
        let uploadedFile = try await supabase.storage.from(SupabaseBucket.medicalRecords.id).upload(path: filePath.absoluteString, file: try Data(contentsOf: filePath))
        
        self.reportPath = uploadedFile.path
        
        let response: LabTest = try await supabase.from(SupabaseTable.labTests.id)
            .update([CodingKeys.reportPath.rawValue: uploadedFile.path, CodingKeys.status.rawValue: LabTestStatus.completed.rawValue])
            .eq(CodingKeys.id.rawValue, value: self.id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    static func fetchAll() async throws -> [LabTest] {
        let response:[LabTest] = try await supabase.from(SupabaseTable.labTests.id).select(supabaseSelectQuery).execute().value
        
        return response
    }
}


enum LabTestStatus: String, Codable, CaseIterable {
    case pending = "pending"
    case inProgress = "in-progress"
    case completed = "completed"
    
    var color: Color {
        switch self {
        case .pending:
            return .yellow
        case .inProgress:
            return .blue
        case .completed:
            return .green
        }
    }
}
