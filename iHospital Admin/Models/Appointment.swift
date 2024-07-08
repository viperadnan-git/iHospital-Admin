//
//  Appointments.swift
//  iHospital Admin
//
//  Created by Aditya on 04/07/24.
//

import Foundation
import Supabase

struct Appointment: Codable, Hashable, Identifiable {
    let id: Int
    let patient: Patient
    let doctor: Doctor
    let user: User
    let date: Date
    let paymentStatus: PaymentStatus
    let appointmentStatus: AppointmentStatus
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case patient
        case doctor
        case user
        case date
        case paymentStatus = "payment_status"
        case appointmentStatus = "appointment_status"
        case createdAt = "created_at"
    }
    
    static func == (lhs: Appointment, rhs: Appointment) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let iso8601Formatter = ISO8601DateFormatter()
    static let supabaseSelectQuery = "*, doctor:doctor_id(*), patient:patient_id(*), user:user_id(*)"
    
    static let sample: Appointment = Appointment(
        id: 1,
        patient: Patient.sample,
        doctor: Doctor.sample,
        date: Date(),
        paymentStatus: .pending,
        appointmentStatus: .pending,
        user: User.sample,
        createdAt: Date()
    )

    init(id: Int = 0, patient: Patient, doctor: Doctor, date: Date, paymentStatus: PaymentStatus, appointmentStatus: AppointmentStatus, user: User, createdAt: Date = Date()) {
        self.id = id
        self.patient = patient
        self.doctor = doctor
        self.date = date
        self.paymentStatus = paymentStatus
        self.appointmentStatus = appointmentStatus
        self.user = user
        self.createdAt = createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        patient = try container.decode(Patient.self, forKey: .patient)
        doctor = try container.decode(Doctor.self, forKey: .doctor)
        user = try container.decode(User.self, forKey: .user)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        
        guard let date = Appointment.iso8601Formatter.date(from: dateString),
              let createdAt = Appointment.iso8601Formatter.date(from: createdAtString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }
        
        self.date = date
        self.createdAt = createdAt
        paymentStatus = try container.decode(PaymentStatus.self, forKey: .paymentStatus)
        appointmentStatus = try container.decode(AppointmentStatus.self, forKey: .appointmentStatus)
    }
    
    static func fetchAllAppointments() async throws -> [Appointment] {
        let response:[Appointment] = try await supabase
            .from(SupabaseTable.appointments.id)
            .select(supabaseSelectQuery)
            .execute()
            .value
        
        return response
    }
}

enum PaymentStatus: String, Codable {
    case paid
    case pending
    case failed
}

enum AppointmentStatus: String, Codable {
    case confirmed
    case pending
    case cancelled
}

enum AppointmentError: Error, LocalizedError {
    case invalidBookingDetails

    var errorDescription: String? {
        switch self {
        case .invalidBookingDetails:
            return "Invalid booking details"
        }
    }
}
