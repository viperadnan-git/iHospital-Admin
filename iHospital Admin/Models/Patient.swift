//
//  Patient.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation

struct Patient: Codable, Hashable, Identifiable {
    let id: UUID
    let userId: UUID
    let firstName: String
    let lastName: String
    let gender: Gender
    let phoneNumber: Int
    let bloodGroup: BloodGroup
    let dateOfBirth: Date
    let height: Double?
    let weight: Double?
    let address: String
    
    // Maps the coding keys to the correct JSON keys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case phoneNumber = "phone_number"
        case bloodGroup = "blood_group"
        case dateOfBirth = "date_of_birth"
        case height
        case weight
        case address
    }
    
    // Computed property to get full name
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    // Sample patient data for previews or testing
    static let sample = Patient(id: UUID(),
                                userId: UUID(),
                                firstName: "John",
                                lastName: "Doe",
                                gender: .male,
                                phoneNumber: 1234567890,
                                bloodGroup: .APositive,
                                dateOfBirth: Date(),
                                height: 5.8,
                                weight: 70,
                                address: "123, Main Street, City, Country")
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    // Custom initializer to handle date decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        gender = try container.decode(Gender.self, forKey: .gender)
        phoneNumber = try container.decode(Int.self, forKey: .phoneNumber)
        bloodGroup = try container.decode(BloodGroup.self, forKey: .bloodGroup)
        
        let dateString = try container.decode(String.self, forKey: .dateOfBirth)
        guard let date = DateFormatter.dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfBirth, in: container, debugDescription: "Invalid date format")
        }
        dateOfBirth = date
        
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        address = try container.decode(String.self, forKey: .address)
    }
    
    init(id: UUID, userId: UUID, firstName: String, lastName: String, gender: Gender, phoneNumber: Int, bloodGroup: BloodGroup, dateOfBirth: Date, height: Double?, weight: Double?, address: String) {
        self.id = id
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.bloodGroup = bloodGroup
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.weight = weight
        self.address = address
    }
    
    // Custom encode method to handle date encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(gender, forKey: .gender)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(bloodGroup, forKey: .bloodGroup)
        try container.encode(DateFormatter.dateFormatter.string(from: dateOfBirth), forKey: .dateOfBirth)
        try container.encodeIfPresent(height, forKey: .height)
        try container.encodeIfPresent(weight, forKey: .weight)
        try container.encode(address, forKey: .address)
    }
    
    // Fetches all patients from the database
    static func fetchAll() async throws -> [Patient] {
        let response: [Patient] = try await supabase.from(SupabaseTable.patients.id)
            .select()
            .execute()
            .value
        
        return response
    }
    
    // Fetches the medical records of the patient
    func fetchMedicalRecords() async throws -> [MedicalRecord] {
        let response: [MedicalRecord] = try await supabase.from(SupabaseTable.medicalRecords.id)
            .select(MedicalRecord.supabaseSelectQuery)
            .eq("patient_id", value: id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response
    }
    
    // Fetches the lab tests of the patient
    func fetchLabTests() async throws -> [LabTest] {
        let response: [LabTest] = try await supabase.from(SupabaseTable.labTests.id)
            .select(LabTest.supabaseSelectQuery)
            .eq("patient_id", value: id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response
    }
    
    // Fetches the invoices of the patient
    func fetchInvoices() async throws -> [Invoice] {
        let response: [Invoice] = try await supabase.from(SupabaseTable.invoices.id)
            .select(Invoice.supabaseSelectQuery)
            .eq("patient_id", value: id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response
    }
}
