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
    supabaseURL: URL(string: SUPABASE_URL)!,
    supabaseKey: SUPABASE_KEY
)

enum SupabaseTable: String {
    case users = "users"
    case roles = "roles"
    case doctors = "doctors"
    case departments = "departments"
}
