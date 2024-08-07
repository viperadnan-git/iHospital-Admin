//
//  Invoice.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

enum PaymentType: String, Codable {
    case appointment
    case labTest = "lab_test"
    case bed
    
    // Returns a user-friendly name for the payment type
    var name: String {
        switch self {
        case .appointment:
            return "Appointment"
        case .labTest:
            return "Lab Test"
        case .bed:
            return "Bed"
        }
    }
}

struct RevenueCount: Codable {
    var todayRevenue: Int
    var totalRevenue: Int
    
    enum CodingKeys: String, CodingKey {
        case todayRevenue = "today_revenue"
        case totalRevenue = "total_revenue"
    }
}

struct Invoice: Identifiable, Codable {
    var id: Int
    var createdAt: Date
    var patientId: UUID
    var userId: UUID
    var amount: Int
    var paymentType: PaymentType
    var referenceId: Int
    var status: PaymentStatus
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case patientId = "patient_id"
        case userId = "user_id"
        case amount
        case paymentType = "payment_type"
        case referenceId = "reference_id"
        case status
    }
    
    static let supabaseSelectQuery = "*"
    
    static let sample = Invoice(id: 1,
                                createdAt: Date(),
                                patientId: UUID(),
                                userId: UUID(),
                                amount: 100,
                                paymentType: .appointment,
                                referenceId: 1,
                                status: .pending)
    
    // Fetches the referenced object based on the payment type
    func fetchReferencedObject() async throws -> Any {
        switch paymentType {
        case .appointment:
            return try await fetchAppointment(referenceId: referenceId)
        case .labTest:
            return try await fetchLabTest(referenceId: referenceId)
        case .bed:
            return try await fetchBedBooking(referenceId: referenceId)
        }
    }
    
    // Fetches the appointment corresponding to the reference ID
    private func fetchAppointment(referenceId: Int) async throws -> Appointment {
        let response: Appointment = try await supabase.from(SupabaseTable.appointments.id)
            .select()
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    // Fetches the lab test corresponding to the reference ID
    private func fetchLabTest(referenceId: Int) async throws -> LabTest {
        let response: LabTest = try await supabase.from(SupabaseTable.labTests.id)
            .select()
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    // Fetches the bed booking corresponding to the reference ID
    private func fetchBedBooking(referenceId: Int) async throws -> BedBooking {
        let response: BedBooking = try await supabase.from(SupabaseTable.bedBookings.id)
            .select()
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    // Fetches the revenue count
    static func fetchRevenue() async throws -> RevenueCount {
        let response: RevenueCount = try await supabase.rpc("get_invoice_totals").execute().value
        return response
    }
}
