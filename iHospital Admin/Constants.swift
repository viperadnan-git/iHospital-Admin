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
    
    
    // MARK: - User Defaults Keys
    static let userInfoKey = "User"
    static let doctorInfoKey = "Doctor"
    
    
    // MARK: - Defaults
    static let doctorFee = 499
    
    // MARK: - PDF Defaults
    struct PDF {
        static let dotsPerInch: CGFloat = 72.0
        static let pageWidth: CGFloat = 8.5
        static let pageHeight: CGFloat = 11.0
    }
}
