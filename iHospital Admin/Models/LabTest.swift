//
//  LabTest.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

struct LabTest: Codable, Identifiable {
    let id: Int
    let name: String
    let patient: Patient
    let status: LabTestStatus
    let appointment: Appointment
    let reportPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case patient
        case status
        case appointment
        case reportPath = "report_path"
    }
    
    static let supabaseSelectQuery = "*, patient:patient_id(*), appointment:appointment_id(\(Appointment.supabaseSelectQuery))"
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
