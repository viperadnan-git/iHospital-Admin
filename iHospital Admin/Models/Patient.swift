//
//  Patient.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation


struct Patient: Codable {
    let patientId: UUID
    let userId: UUID
    let firstName: String
    let lastName: String
    let phoneNumber: Int
    let bloodGroup: BloodGroup
    let dateOfBirth: Date
    let height: Double?
    let weight: Double?
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case patientId = "id"
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case bloodGroup = "blood_group"
        case dateOfBirth = "date_of_birth"
        case height
        case weight
        case address
    }
    
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let sample = Patient(patientId: UUID(),
                userId: UUID(),
                firstName: "John",
                lastName: "Doe",
                phoneNumber: 1234567890,
                bloodGroup: .APositive,
                dateOfBirth: Date(),
                height: 5.8,
                weight: 70,
                address: "123, Main Street, City, Country")
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        patientId = try container.decode(UUID.self, forKey: .patientId)
        userId = try container.decode(UUID.self, forKey: .userId)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phoneNumber = try container.decode(Int.self, forKey: .phoneNumber)
        bloodGroup = try container.decode(BloodGroup.self, forKey: .bloodGroup)
        
        let dateString = try container.decode(String.self, forKey: .dateOfBirth)
        guard let date = Patient.dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfBirth, in: container, debugDescription: "Invalid date format")
        }
        dateOfBirth = date
        
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        address = try container.decode(String.self, forKey: .address)
    }
    
    init(patientId: UUID, userId: UUID, firstName: String, lastName:String, phoneNumber: Int, bloodGroup: BloodGroup, dateOfBirth: Date, height: Double?, weight: Double?, address: String) {
        self.patientId = patientId
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.bloodGroup = bloodGroup
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.weight = weight
        self.address = address
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(patientId, forKey: .patientId)
        try container.encode(userId, forKey: .userId)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(bloodGroup, forKey: .bloodGroup)
        try container.encode(Patient.dateFormatter.string(from: dateOfBirth), forKey: .dateOfBirth)
        try container.encodeIfPresent(height, forKey: .height)
        try container.encodeIfPresent(weight, forKey: .weight)
        try container.encode(address, forKey: .address)
    }

    
    static func fetchAll() async throws -> [Patient] {
        let response:[Patient] = try await supabase.from(SupabaseTable.patients.id)
            .select()
            .execute()
            .value
        
      
        return response
    }
}
