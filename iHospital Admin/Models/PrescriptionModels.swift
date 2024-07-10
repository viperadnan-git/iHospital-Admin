//
//  PrescriptionModels.swift
//  iHospital Admin
//
//  Created by Nitin ‘s on 10/07/24.
//

import Foundation

struct Medicine: Identifiable {
    let id = UUID()
    var name: String = ""
    var dosage: Int = 1
}

struct LabTest: Identifiable {
    let id = UUID()
    var name: String = ""
}

struct LabTestItem: Identifiable {
    var id = UUID()
    var name: String = ""
    var selectedTest: String = ""
}

