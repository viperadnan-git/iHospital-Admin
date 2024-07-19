//
//  Constants.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation

struct Constants {
    // MARK: - Supabase Constants
    static let supabaseURL = "https://abnyxrflmgrmvelohwpu.supabase.co"
    static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFibnl4cmZsbWdybXZlbG9od3B1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk0NjE0MDIsImV4cCI6MjAzNTAzNzQwMn0.1kh8Ml9krT1fj821xNHS5hP2keSaPN9hYxUFOo0yPR4"
    
    static let localSupabaseURL = "http://172.20.10.3:8000"
    static let localSupabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzIxMjQxMDAwLAogICJleHAiOiAxODc5MDA3NDAwCn0.Q-pfkuBPpR51hqSnbOzXySLszv6uqP3gYk1klkx3_MA"
    
    
    // MARK: - User Defaults Keys
    static let userInfoKey = "User"
    static let doctorInfoKey = "Doctor"
    
    
    // MARK: - Defaults
    static let doctorFee = 499
    static let currencyCode = "INR"
}
