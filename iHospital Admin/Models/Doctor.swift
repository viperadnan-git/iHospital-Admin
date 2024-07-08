//
//  Doctor.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation
import Supabase

struct Doctor: Codable, Hashable {
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
    var settings: DoctorSettings?
    
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
        case settings = "doctor_settings"
    }
    
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        lhs.userId == rhs.userId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
    
    static let supabaseSelectQuery = "*, doctor_settings(*)"
    
    static var sample: Doctor {
        Doctor(userId: UUID(),
               name: "Dr. John Doe",
               dateOfBirth: Date(),
               gender: .male,
               phoneNumber: 1234567890,
               email: "doctor@ihospital.viperadnan.com",
               qualification: "MBBS",
               experienceSince: Date(),
               dateOfJoining: Date(),
               departmentId: UUID(),
               settings: nil)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let encoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(UUID.self, forKey: .userId)
        name = try container.decode(String.self, forKey: .name)
        
        let dateOfBirthString = try container.decode(String.self, forKey: .dateOfBirth)
        let dateOfJoiningString = try container.decode(String.self, forKey: .dateOfJoining)
        let experienceSinceString = try container.decode(String.self, forKey: .experienceSince)
        
        guard let dateOfBirth = Doctor.dateFormatter.date(from: dateOfBirthString),
              let dateOfJoining = Doctor.dateFormatter.date(from: dateOfJoiningString),
              let experienceSince = Doctor.dateFormatter.date(from: experienceSinceString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfBirth, in: container, debugDescription: "Invalid date format")
        }
        self.dateOfBirth = dateOfBirth
        self.dateOfJoining = dateOfJoining
        self.experienceSince = experienceSince
        
        gender = try container.decode(Gender.self, forKey: .gender)
        phoneNumber = try container.decode(Int.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        qualification = try container.decode(String.self, forKey: .qualification)
        departmentId = try container.decode(UUID.self, forKey: .departmentId)
        settings = try container.decodeIfPresent(DoctorSettings.self, forKey: .settings) ?? DoctorSettings.getDefaultSettings(userId: userId)
    }
    
    init(userId: UUID, name: String, dateOfBirth: Date, gender: Gender, phoneNumber: Int, email: String, qualification: String, experienceSince: Date, dateOfJoining: Date, departmentId: UUID, settings: DoctorSettings?) {
        self.userId = userId
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.email = email
        self.qualification = qualification
        self.experienceSince = experienceSince
        self.dateOfJoining = dateOfJoining
        self.departmentId = departmentId
        self.settings = settings
    }

    
    static func fetchDepartmentWise(departmentId: UUID) async throws -> [Doctor] {
        let response:[Doctor] = try await supabase.from(SupabaseTable.doctors.rawValue)
            .select(supabaseSelectQuery)
            .eq("department_id", value: departmentId)
            .execute()
            .value
        
        return response
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
            departmentId: departmentId,
            settings: nil
        )
        
        try await supabase.from(SupabaseTable.doctors.id)
            .insert(newDoctor)
            .execute()
        try await supabase.from(SupabaseTable.roles.id)
            .insert(Role(userId: session.user.id, role: .doctor))
            .execute()
    }
    
    static func getMe() async throws -> Doctor {
        // TODO: Implement cache
        let me = try await getMeFromSupabase()
        return me
    }
    
    private static func getMeFromSupabase() async throws -> Doctor {
        guard let user = SupaUser.shared?.user else {
            throw SupabaseError.unauthorized
        }
        
        let response:Doctor = try await supabase.from(SupabaseTable.doctors.id)
            .select(supabaseSelectQuery)
            .eq("user_id", value: user.id)
            .single()
            .execute()
            .value
        
        return response
    }
    
    func fetchAppointments() async throws -> [Appointment] {
        let response = try await supabase.from(SupabaseTable.appointments.id)
            .select(Appointment.supabaseSelectQuery)
            .eq("doctor_id", value: userId)
            .execute()
        
        return try JSONDecoder().decode([Appointment].self, from: response.data)
    }
}
