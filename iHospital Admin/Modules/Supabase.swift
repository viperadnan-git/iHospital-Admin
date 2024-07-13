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
    case users = "users"
    case roles = "roles"
    case doctors = "doctors"
    case departments = "departments"
    case patients = "patients"
    case appointments = "appointments"
    case medicalRecords = "medical_records"
    case labTests = "lab_tests"
    
    var id: String {
        self.rawValue
    }
}

enum SupabaseBucket: String {
    case avatar = "avatars"
    case medicalRecords = "medical_records"
    
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
