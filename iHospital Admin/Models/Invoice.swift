//
//  Invoice.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

enum PaymentType: String, Codable {
    case appointment = "appointment"
    case labTest = "lab_test"
    case bed = "bed"
}

enum Reference: Codable {
    case appointment(Appointment)
    case labTest(LabTest)
    case bedBooking(BedBooking)
    
    enum CodingKeys: String, CodingKey {
        case appointment, labTest, bedBooking
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let appointment = try? container.decode(Appointment.self, forKey: .appointment) {
            self = .appointment(appointment)
            return
        }
        if let labTest = try? container.decode(LabTest.self, forKey: .labTest) {
            self = .labTest(labTest)
            return
        }
        if let bedBooking = try? container.decode(BedBooking.self, forKey: .bedBooking) {
            self = .bedBooking(bedBooking)
            return
        }
        
        throw DecodingError.dataCorruptedError(forKey: CodingKeys.appointment, in: container, debugDescription: "Unable to decode Reference")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .appointment(let appointment):
            try container.encode(appointment, forKey: .appointment)
        case .labTest(let labTest):
            try container.encode(labTest, forKey: .labTest)
        case .bedBooking(let bedBooking):
            try container.encode(bedBooking, forKey: .bedBooking)
        }
    }
}

class Invoice: Codable, Identifiable {
    let id: Int
    let createdAt: Date
    let patientId: UUID
    let userId: UUID
    let amount: Decimal
    let paymentType: PaymentType
    let reference: Reference
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case patientId = "patient_id"
        case userId = "user_id"
        case amount
        case paymentType = "payment_type"
        case reference
        case status
    }
    
    init(id: Int, createdAt: Date, patientId: UUID, userId: UUID, amount: Decimal, paymentType: PaymentType, reference: Reference, status: String) {
        self.id = id
        self.createdAt = createdAt
        self.patientId = patientId
        self.userId = userId
        self.amount = amount
        self.paymentType = paymentType
        self.reference = reference
        self.status = status
    }
    
    convenience init(id: Int, createdAt: Date, patientId: UUID, userId: UUID, amount: Decimal, referenceId: Int, status: String, appointment: Appointment) {
        self.init(id: id, createdAt: createdAt, patientId: patientId, userId: userId, amount: amount, paymentType: .appointment, reference: .appointment(appointment), status: status)
    }
    
    convenience init(id: Int, createdAt: Date, patientId: UUID, userId: UUID, amount: Decimal, referenceId: Int, status: String, labTest: LabTest) {
        self.init(id: id, createdAt: createdAt, patientId: patientId, userId: userId, amount: amount, paymentType: .labTest, reference: .labTest(labTest), status: status)
    }
    
    convenience init(id: Int, createdAt: Date, patientId: UUID, userId: UUID, amount: Decimal, referenceId: Int, status: String, bedBooking: BedBooking) {
        self.init(id: id, createdAt: createdAt, patientId: patientId, userId: userId, amount: amount, paymentType: .bed, reference: .bedBooking(bedBooking), status: status)
    }
    
    // Custom decoding for the reference key to handle different types
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        patientId = try container.decode(UUID.self, forKey: .patientId)
        userId = try container.decode(UUID.self, forKey: .userId)
        amount = try container.decode(Decimal.self, forKey: .amount)
        paymentType = try container.decode(PaymentType.self, forKey: .paymentType)
        status = try container.decode(String.self, forKey: .status)
        
        // Decode the reference based on the payment type
        switch paymentType {
        case .appointment:
            let appointment = try container.decode(Appointment.self, forKey: .reference)
            reference = .appointment(appointment)
        case .labTest:
            let labTest = try container.decode(LabTest.self, forKey: .reference)
            reference = .labTest(labTest)
        case .bed:
            let bedBooking = try container.decode(BedBooking.self, forKey: .reference)
            reference = .bedBooking(bedBooking)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(patientId, forKey: .patientId)
        try container.encode(userId, forKey: .userId)
        try container.encode(amount, forKey: .amount)
        try container.encode(paymentType, forKey: .paymentType)
        try container.encode(status, forKey: .status)
        
        switch reference {
        case .appointment(let appointment):
            try container.encode(appointment, forKey: .reference)
        case .labTest(let labTest):
            try container.encode(labTest, forKey: .reference)
        case .bedBooking(let bedBooking):
            try container.encode(bedBooking, forKey: .reference)
        }
    }
}
