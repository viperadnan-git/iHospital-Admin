//
//  Staff.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 14/07/24.
//

import Foundation
import Supabase
import Auth

class Staff: Codable, Identifiable, Hashable {
    let id: Int
    let userId: UUID?
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var gender: Gender
    var email: String
    var phoneNumber: Int
    var address: String
    var dateOfJoining: Date
    var qualification: String
    var experienceSince: Date
    var type: StaffDepartment
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case gender
        case email
        case phoneNumber = "phone_number"
        case address
        case dateOfJoining = "date_of_joining"
        case qualification
        case experienceSince = "experience_since"
        case type
    }
    
    static func == (lhs: Staff, rhs: Staff) -> Bool {
        lhs.userId == rhs.userId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
    
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    static let supabaseSelectQuery = "*"
    
    static var sample: Staff {
        return Staff(id: 1,
                     userId: UUID(),
                     firstName: "Jane",
                     lastName: "Doe",
                     dateOfBirth: Date(),
                     gender: .female,
                     email: "staff@mail.viperadnan.com",
                     phoneNumber: 9876543210,
                     address: "123 Main St",
                     dateOfJoining: Date(),
                     qualification: "B.Sc Nursing",
                     experienceSince: Date(),
                     type: .nursing)
    }
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.dateFormatter)
        return encoder
    }()
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decodeIfPresent(UUID.self, forKey: .userId)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        
        let dateOfBirthString = try container.decode(String.self, forKey: .dateOfBirth)
        let dateOfJoiningString = try container.decode(String.self, forKey: .dateOfJoining)
        let experienceSinceString = try container.decode(String.self, forKey: .experienceSince)
        
        guard let dateOfBirth = DateFormatter.dateFormatter.date(from: dateOfBirthString),
              let dateOfJoining = DateFormatter.dateFormatter.date(from: dateOfJoiningString),
              let experienceSince = DateFormatter.dateFormatter.date(from: experienceSinceString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfBirth, in: container, debugDescription: "Invalid date format")
        }
        self.dateOfBirth = dateOfBirth
        self.dateOfJoining = dateOfJoining
        self.experienceSince = experienceSince
        
        gender = try container.decode(Gender.self, forKey: .gender)
        email = try container.decode(String.self, forKey: .email)
        phoneNumber = try container.decode(Int.self, forKey: .phoneNumber)
        address = try container.decode(String.self, forKey: .address)
        qualification = try container.decode(String.self, forKey: .qualification)
        type = try container.decode(StaffDepartment.self, forKey: .type)
    }
    
    init(id: Int, userId: UUID?, firstName: String, lastName:String, dateOfBirth: Date, gender: Gender, email:String, phoneNumber: Int, address: String, dateOfJoining: Date, qualification: String, experienceSince: Date, type: StaffDepartment) {
        self.id = id
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.dateOfJoining = dateOfJoining
        self.qualification = qualification
        self.experienceSince = experienceSince
        self.type = type
    }
    
    func save() async throws {
        var updateData: [String: String] = [
            "first_name": firstName,
            "last_name": lastName,
            "date_of_birth": DateFormatter.dateFormatter.string(from: dateOfBirth),
            "gender": gender.id,
            "phone_number": phoneNumber.string,
            "address": address,
            "qualification": qualification,
            "experience_since": DateFormatter.dateFormatter.string(from: experienceSince),
            "date_of_joining": DateFormatter.dateFormatter.string(from: dateOfJoining),
            "type": type.rawValue
        ]
        
        if type != .labTechnician{
            updateData["email"] = email
        }
        
        try await supabase.from(SupabaseTable.staffs.id)
            .update(updateData)
            .eq("id", value: id)
            .execute()
    }
    
    static func fetchDepartmentWise(department: StaffDepartment) async throws -> [Staff] {
        let response = try await supabase.from(SupabaseTable.staffs.id)
            .select(supabaseSelectQuery)
            .eq("type", value: department.rawValue)
            .execute()
        
        return try JSONDecoder().decode([Staff].self, from: response.data)
    }
    
    static func fetchAllStaff(for department: StaffDepartment) async throws -> [Staff] {
        let response = try await supabase.from(SupabaseTable.staffs.id)
            .select(supabaseSelectQuery)
            .eq("type", value: department.rawValue)
            .execute()
        
        return try JSONDecoder().decode([Staff].self, from: response.data)
    }
    
    static func new(firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, email:String, phoneNumber: Int, address: String, dateOfJoining: Date, qualification: String, experienceSince: Date, type: StaffDepartment) async throws -> Staff {
        var userId: UUID? = nil
        var signupResponse: AuthResponse? = nil
        
        if type == .labTechnician {
            signupResponse = try await supabase.auth.signUp(email: email, password: UUID().uuidString)
            userId = signupResponse?.user.id
        }
        
        let staff: Staff = try await supabase.from(SupabaseTable.staffs.id)
            .insert([
                "user_id": userId?.uuidString,
                "first_name": firstName,
                "last_name": lastName,
                "date_of_birth": dateOfBirth.ISO8601Format(),
                "gender": gender.id,
                "email": email,
                "phone_number": String(phoneNumber),
                "address": address,
                "qualification": qualification,
                "experience_since": experienceSince.ISO8601Format(),
                "date_of_joining": dateOfJoining.ISO8601Format(),
                "type": type.rawValue
            ])
            .select(supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        if let userId = userId {
            try await supabase.from(SupabaseTable.roles.id)
                .insert(Role(userId: userId, role: .labTech))
                .execute()
        }
        
        return staff
    }
    
    static func getMe() async throws -> Staff {
        // TODO: Implement cache
        let me = try await getMeFromSupabase()
        return me
    }
    
    private static func getMeFromSupabase() async throws -> Staff {
        guard let user = SupaUser.shared?.user else {
            throw SupabaseError.unauthorized
        }
        
        let response: Staff = try await supabase.from(SupabaseTable.staffs.id)
            .select(supabaseSelectQuery)
            .eq("user_id", value: user.id)
            .single()
            .execute()
            .value
        
        return response
    }
}
