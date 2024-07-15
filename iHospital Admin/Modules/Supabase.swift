//
//  Supabase.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//


import Foundation
import SwiftUI
import Supabase
import Auth

let supabase = SupabaseClient(
    supabaseURL: URL(string: Constants.supabaseURL)!,
    supabaseKey: Constants.supabaseKey,
    options: .init(auth: .init(flowType: .implicit))
)

enum SupabaseTable: String {
    case users
    case roles
    case doctors
    case departments
    case patients
    case appointments
    case medicalRecords = "medical_records"
    case labTests = "lab_tests"
    case staffs
    case labTestTypes = "lab_test_types"
    case invoices
    
    var id: String {
        self.rawValue
    }
}

enum SupabaseBucket: String {
    case avatar = "avatars"
    case medicalRecords = "medical_records"
    case labReports = "lab_reports"
    
    var id: String {
        self.rawValue
    }
}


enum SupabaseError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidUser
    case invalidRole
    case invalidDoctor
    case invalidDepartment
    case unauthorized
}
