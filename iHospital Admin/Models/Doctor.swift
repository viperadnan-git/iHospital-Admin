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
    let firstName: String
    let lastName: String
    let dateOfBirth: Date
    let gender: Gender
    let phoneNumber: Int
    let email: String
    let qualification: String
    let experienceSince: Date
    let dateOfJoining: Date
    let departmentId: UUID
    var doctorSettings: DoctorSettings?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case gender
        case phoneNumber = "phone_number"
        case email
        case qualification
        case experienceSince = "experience_since"
        case dateOfJoining = "date_of_joining"
        case departmentId = "department_id"
        case doctorSettings = "doctor_settings"
    }
    
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        lhs.userId == rhs.userId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
    
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    var settings: DoctorSettings {
        doctorSettings ?? DoctorSettings.getDefaultSettings(userId: userId)
    }
    
    static let supabaseSelectQuery = "*, doctor_settings(*)"
    
    static var sample: Doctor {
        let userId = UUID()
        return Doctor(userId: userId,
                      firstName: "John",
                      lastName: "Doe",
                      dateOfBirth: Date(),
                      gender: .male,
                      phoneNumber: 1234567890,
                      email: "doctor@ihospital.viperadnan.com",
                      qualification: "MBBS",
                      experienceSince: Date(),
                      dateOfJoining: Date(),
                      departmentId: UUID(),
                      doctorSettings: DoctorSettings.getDefaultSettings(userId: userId))
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
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        
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
        
        doctorSettings = try? container.decodeIfPresent(DoctorSettings.self, forKey: .doctorSettings)
    }
    
    init(userId: UUID, firstName: String, lastName:String, dateOfBirth: Date, gender: Gender, phoneNumber: Int, email: String, qualification: String, experienceSince: Date, dateOfJoining: Date, departmentId: UUID, doctorSettings: DoctorSettings) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.email = email
        self.qualification = qualification
        self.experienceSince = experienceSince
        self.dateOfJoining = dateOfJoining
        self.departmentId = departmentId
        self.doctorSettings = doctorSettings
    }
    
    static func fetchDepartmentWise(departmentId: UUID) async throws -> [Doctor] {
        let response = try await supabase.from(SupabaseTable.doctors.id)
            .select(supabaseSelectQuery)
            .eq("department_id", value: departmentId)
            .execute()
        
        return try JSONDecoder().decode([Doctor].self, from: response.data)
    }
    
    static func addDoctor(firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, phoneNumber: Int, email: String, qualification: String, experienceSince: Date, dateOfJoining: Date, departmentId: UUID) async throws -> Doctor {
        let session = try await supabase.auth.signUp(email: email, password: UUID().uuidString)
        
        let doctor: Doctor = try await supabase.from(SupabaseTable.doctors.id)
            .insert([
                "user_id": session.user.id.uuidString,
                "first_name": firstName,
                "last_name": lastName,
                "date_of_birth": dateFormatter.string(from: dateOfBirth),
                "gender": gender.id,
                "phone_number": String(phoneNumber),
                "email": email,
                "qualification": qualification,
                "experience_since": dateFormatter.string(from: experienceSince),
                "date_of_joining": dateFormatter.string(from: dateOfJoining),
                "department_id": departmentId.uuidString
            ])
            .select(supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        try await supabase.from(SupabaseTable.roles.id)
            .insert(Role(userId: session.user.id, role: .doctor))
            .execute()
        
        return doctor
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
        
        let response: Doctor = try await supabase.from(SupabaseTable.doctors.id)
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
