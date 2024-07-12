//
//  LabTest.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

struct LabTest: Codable {
    let id: UUID
    let name: String
    let patient: Patient
    let sampleId: String?
    let reportPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case patient
        case sampleId = "sample_id"
        case reportPath = "report_path"
    }
}
