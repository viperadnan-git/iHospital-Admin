//
//  Doctor.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation
import Supabase

class Doctor: Codable, Hashable {
    let userId: UUID
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var gender: Gender
    var phoneNumber: Int
    let email: String
    var qualification: String
    var experienceSince: Date
    var dateOfJoining: Date
    var departmentId: UUID
    var fee: Int
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
        case fee
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
                      fee: 399,
                      doctorSettings: DoctorSettings.getDefaultSettings(userId: userId))
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    required init(from decoder: Decoder) throws {
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
        fee = try container.decode(Int.self, forKey: .fee)
        
        doctorSettings = try? container.decodeIfPresent(DoctorSettings.self, forKey: .doctorSettings)
    }
    
    init(userId: UUID, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, phoneNumber: Int, email: String, qualification: String, experienceSince: Date, dateOfJoining: Date, departmentId: UUID, fee: Int, doctorSettings: DoctorSettings?) {
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
        self.fee = fee
        self.doctorSettings = doctorSettings
    }
    
    func save() async throws {
        try await supabase.from(SupabaseTable.doctors.id)
            .update(
                [
                    "first_name": firstName,
                    "last_name": lastName,
                    "date_of_birth": Doctor.dateFormatter.string(from: dateOfBirth),
                    "gender": gender.id,
                    "phone_number": phoneNumber.string,
                    "qualification": qualification,
                    "experience_since": Doctor.dateFormatter.string(from: experienceSince),
                    "date_of_joining": Doctor.dateFormatter.string(from: dateOfJoining),
                    "department_id": departmentId.uuidString
                ]
            )
            .execute()
    }
    
    static func fetchDepartmentWise(departmentId: UUID) async throws -> [Doctor] {
        let response = try await supabase.from(SupabaseTable.doctors.id)
            .select(supabaseSelectQuery)
            .eq("department_id", value: departmentId)
            .execute()
        
        return try JSONDecoder().decode([Doctor].self, from: response.data)
    }
    
    static func new(doctor: Doctor) async throws -> Doctor {
        let session = try await supabase.auth.signUp(email: doctor.email, password: UUID().uuidString)
        
        let newDoctor: Doctor = try await supabase.from(SupabaseTable.doctors.id)
            .insert([
                "user_id": session.user.id.uuidString,
                "first_name": doctor.firstName,
                "last_name": doctor.lastName,
                "date_of_birth": dateFormatter.string(from: doctor.dateOfBirth),
                "gender": doctor.gender.id,
                "phone_number": doctor.phoneNumber.string,
                "email": doctor.email,
                "qualification": doctor.qualification,
                "experience_since": dateFormatter.string(from: doctor.experienceSince),
                "date_of_joining": dateFormatter.string(from: doctor.dateOfJoining),
                "fee": doctor.fee.string,
                "department_id": doctor.departmentId.uuidString
            ])
            .select(supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        try await supabase.from(SupabaseTable.roles.id)
            .insert(Role(userId: session.user.id, role: .doctor))
            .execute()
        
        return newDoctor
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
        let response: [Appointment] = try await supabase.from(SupabaseTable.appointments.id)
            .select(Appointment.supabaseSelectQuery)
            .eq("doctor_id", value: userId)
            .execute()
            .value
        
        return response
    }
    
    func fetchAppointments(for date: Date) async throws -> [Appointment] {
        let response: [Appointment] = try await supabase.from(SupabaseTable.appointments.id)
            .select(Appointment.supabaseSelectQuery)
            .eq("doctor_id", value: userId)
            .gte("date", value: date.startOfDay.ISO8601Format())
            .lt("date", value: date.endOfDay.ISO8601Format())
            .execute()
            .value
        
        return response
    }
    
    func delete() async throws {
        try await supabase.from(SupabaseTable.doctors.id)
            .delete()
            .eq("user_id", value: userId)
            .execute()
    }
    
    static func count() async throws -> Int {
        let response = try await supabase.from(SupabaseTable.doctors.id)
            .select("*", head: true, count: .exact)
            .execute()
            .count
        
        return response ?? 0
    }
}
