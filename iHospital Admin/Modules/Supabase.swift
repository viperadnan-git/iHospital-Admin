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

// Initialize the Supabase client with the necessary URL and key
let supabase = SupabaseClient(
    supabaseURL: URL(string: Constants.supabaseURL)!,
    supabaseKey: Constants.supabaseKey,
    options: .init(auth: .init(flowType: .implicit))
)

// Enum for Supabase tables
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
    case bedBookings = "bed_bookings"
    
    // Returns the raw value of the enum as the id
    var id: String {
        self.rawValue
    }
}

// Enum for Supabase storage buckets
enum SupabaseBucket: String {
    case avatars
    case medicalRecords = "medical_records"
    case labReports = "lab_reports"
    
    // Returns the raw value of the enum as the id
    var id: String {
        self.rawValue
    }
}

// Enum for Supabase-related errors
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
