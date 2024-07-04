//
//  Doctor.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation
import Supabase

struct Doctor: Codable {
    let userId: UUID
    let name: String
    let dateOfBirth: Date
    let gender: Gender
    let phoneNumber: Int
    let email: String
    let qualification: String
    let experienceSince: Date
    let dateOfJoining: Date
    let departmentId: UUID
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name
        case dateOfBirth = "date_of_birth"
        case gender
        case phoneNumber = "phone_number"
        case email
        case qualification
        case experienceSince = "experience_since"
        case dateOfJoining = "date_of_joining"
        case departmentId = "department_id"
    }
    
    static func fetchAll() async throws -> [Doctor] {
        let response: [Doctor] = try await supabase.from(SupabaseTable.doctors.rawValue)
            .select()
            .execute()
            .value
        
        return response
    }
    
    static var decoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    static var encoder = {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    static func fetchDepartmentWise(departmentId: UUID) async throws -> [Doctor] {
        let response = try await supabase.from(SupabaseTable.doctors.rawValue)
            .select()
            .eq("department_id", value: departmentId)
            .execute()
        
        return try decoder.decode([Doctor].self, from: response.data)
    }
    
    static func addDoctor(name: String, dateOfBirth: Date, gender: Gender, phoneNumber: Int, email: String, qualification: String, experienceSince: Date, dateOfJoining: Date, departmentId: UUID) async throws {
        let session = try await supabase.auth.signUp(email: email, password: UUID().uuidString)
        
        let newDoctor = Doctor(
            userId: session.user.id,
            name: name,
            dateOfBirth: dateOfBirth,
            gender: gender,
            phoneNumber: phoneNumber,
            email: email,
            qualification: qualification,
            experienceSince: experienceSince,
            dateOfJoining: dateOfJoining,
            departmentId: departmentId
        )
        
        try await supabase.from(SupabaseTable.doctors.id)
            .insert(newDoctor)
            .execute()
        try await supabase.from(SupabaseTable.roles.id)
            .insert(Role(userId: session.user.id, role: .doctor))
            .execute()
    }
    
    static func getMe() async throws -> Doctor {
        if let data = UserDefaults.standard.data(forKey: DOCTOR_INFO_KEY) {
            Task {
                do {
                    let me = try await getMeFromSupabase()
                    if let data = try? encoder.encode(me) {
                        UserDefaults.standard.set(data, forKey: DOCTOR_INFO_KEY)
                    }
                } catch {
                    print("Error while checking doctor info: \(error)")
                    try await SupaUser.logOut()
                }
            }
            
            return try decoder.decode(Doctor.self, from: data)
        }
        
        let me = try await getMeFromSupabase()
        
        if let data = try? encoder.encode(me) {
            UserDefaults.standard.set(data, forKey: DOCTOR_INFO_KEY)
        }
        
        return me
    }
    
    private static func getMeFromSupabase() async throws -> Doctor {
        guard let user = SupaUser.shared?.user else {
            throw SupabaseError.unauthorized
        }
        
        let response = try await supabase.from(SupabaseTable.doctors.id)
            .select()
            .eq("user_id", value: user.id)
            .single()
            .execute()
        
        return try decoder.decode(Doctor.self, from: response.data)
    }
}
