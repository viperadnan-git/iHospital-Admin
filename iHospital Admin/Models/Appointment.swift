//
//  Appointments.swift
//  iHospital Admin
//
//  Created by Aditya on 04/07/24.
//

import Foundation
import Supabase
import SwiftUI

class Appointment: Codable, Hashable, Identifiable {
    let id: Int
    let patient: Patient
    let doctor: Doctor
    let user: User
    let date: Date
    var paymentStatus: PaymentStatus
    var status: AppointmentStatus
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case patient
        case doctor
        case user
        case date
        case paymentStatus = "payment_status"
        case status = "appointment_status"
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
        status: .pending,
        user: User.sample,
        createdAt: Date()
    )

    init(id: Int = 0, patient: Patient, doctor: Doctor, date: Date, paymentStatus: PaymentStatus, status: AppointmentStatus, user: User, createdAt: Date = Date()) {
        self.id = id
        self.patient = patient
        self.doctor = doctor
        self.date = date
        self.paymentStatus = paymentStatus
        self.status = status
        self.user = user
        self.createdAt = createdAt
    }
    
    required init(from decoder: Decoder) throws {
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
        status = try container.decode(AppointmentStatus.self, forKey: .status)
    }
    
    
    static var allAppointments: [Appointment] = []
    
    static func fetchAppointments(force: Bool = false) async throws -> [Appointment] {
        if !force, !allAppointments.isEmpty {
            return allAppointments
        }

        let response:[Appointment] = try await supabase
            .from(SupabaseTable.appointments.id)
            .select(supabaseSelectQuery)
            .execute()
            .value
        
        return response
    }
    
    static func fetchAppointments(forDate date: Date) async throws -> [Appointment] {
        let response:[Appointment] = try await supabase
            .from(SupabaseTable.appointments.id)
            .select(supabaseSelectQuery)
            .gte("date", value: date.startOfDay.ISO8601Format())
            .lte("date", value: date.endOfDay.ISO8601Format())
            .execute()
            .value
        
        return response
    }
    
    func saveImage(fileName:String, data: Data) async throws -> String {
        let name = "\(id.string)/\(fileName).png"
        let response = try await supabase.storage.from(SupabaseBucket.medicalRecords.id).upload(path: name, file: data)
        
        return response.path
    }
    
    func updateStatus(_ status: AppointmentStatus) async throws {
        self.status = status
        try await supabase.from(SupabaseTable.appointments.id)
            .update([
                "appointment_status": status.rawValue
            ])
            .eq("id", value: id)
            .execute()
    }
}

enum PaymentStatus: String, Codable {
    case paid
    case pending
    case failed
    case cancelled
    
    var color: Color {
        switch self {
        case .paid:
            return .green
        case .pending:
            return .yellow
        case .failed:
            return .red
        case .cancelled:
            return .red
        }
    }
}

enum AppointmentStatus: String, Codable {
    case completed
    case confirmed
    case pending
    case cancelled
    
    var color: Color {
        switch self {
        case .completed:
            return .green
        case .confirmed:
            return .blue
        case .pending:
            return .yellow
        case .cancelled:
            return .red
        }
    }
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
