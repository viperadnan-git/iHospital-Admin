//
//  LabTest.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

class LabTest: Codable, Identifiable {
    let id: Int
    let test: LabTestType
    let patient: Patient
    var status: LabTestStatus
    let appointment: Appointment
    var sampleID: String?
    var reportPath: String?
    
    var reportName: String {
        return URL(string: reportPath ?? "")?.lastPathComponent ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case test
        case patient
        case status
        case appointment
        case sampleID = "sample_id"
        case reportPath = "report_path"
    }
    
    static let supabaseSelectQuery = "*, test:test_id(*), patient:patient_id(*), appointment:appointment_id(\(Appointment.supabaseSelectQuery))"
    
    static let sample = LabTest(id: 1, test: LabTestType.sample, patient: Patient.sample, status: .pending, appointment: Appointment.sample, sampleID: nil, reportPath: nil)
    
    init(id: Int, test: LabTestType, patient: Patient, status: LabTestStatus, appointment: Appointment, sampleID: String?, reportPath: String?) {
        self.id = id
        self.test = test
        self.patient = patient
        self.status = status
        self.appointment = appointment
        self.sampleID = sampleID
        self.reportPath = reportPath
    }
    
    // Updates the sample ID and status of the lab test
    func updateSampleID(_ sampleID: String) async throws -> LabTest {
        self.sampleID = sampleID
        
        let response: LabTest = try await supabase.from(SupabaseTable.labTests.id)
            .update([CodingKeys.sampleID.rawValue: sampleID, CodingKeys.status.rawValue: LabTestStatus.inProgress.rawValue])
            .eq(CodingKeys.id.rawValue, value: self.id)
            .select(LabTest.supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        return response
    }
    
    // Uploads a report and updates the lab test status
    func uploadReport(_ filePath: URL) async throws -> LabTest {
        let name = "\(id)/\(filePath.lastPathComponent)"
        let uploadedFile = try await supabase.storage.from(SupabaseBucket.labReports.id).upload(path: name, file: try Data(contentsOf: filePath))

        self.reportPath = uploadedFile.path

        let response: LabTest = try await supabase.from(SupabaseTable.labTests.id)
            .update([CodingKeys.reportPath.rawValue: uploadedFile.path, CodingKeys.status.rawValue: LabTestStatus.completed.rawValue])
            .eq(CodingKeys.id.rawValue, value: self.id)
            .select(LabTest.supabaseSelectQuery)
            .single()
            .execute()
            .value

        return response
    }
    
    // Downloads the report for the lab test
    func downloadReport() async throws -> URL {
        guard let reportPath = self.reportPath else {
            throw SupabaseError.invalidData
        }
        
        let fileName = "\(id)_\(reportName)"
        
        if let url = FileManager.tempFileExists(fileName: fileName) {
            return url
        }
        
        let response = try await supabase.storage.from(SupabaseBucket.labReports.id).download(path: reportPath)
        
        let url = try FileManager.saveToTempDirectory(fileName: fileName, data: response)
        
        return url
    }
    
    // Fetches all lab tests from the database
    static func fetchAll() async throws -> [LabTest] {
        let response: [LabTest] = try await supabase.from(SupabaseTable.labTests.id).select(supabaseSelectQuery).execute().value
        
        return response
    }
    
    // Counts the number of lab tests in the database
    static func count() async throws -> Int {
        let response = try await supabase.from(SupabaseTable.labTests.id)
            .select("*", head: true, count: .exact)
            .execute()
            .count
        
        return response ?? 0
    }
}

enum LabTestStatus: String, Codable, CaseIterable {
    case pending
    case waiting
    case inProgress = "in-progress"
    case completed
    
    // Provides a color representation of the lab test status
    var color: Color {
        switch self {
        case .pending:
            return .yellow
        case .waiting:
            return .purple
        case .inProgress:
            return .blue
        case .completed:
            return .green
        }
    }
}
