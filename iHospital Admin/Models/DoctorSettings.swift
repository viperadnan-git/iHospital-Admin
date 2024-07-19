//
//  DoctorSettings.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation

class DoctorSettings: Codable {
    let doctorId: UUID
    var priorBookingDays: Int
    var startTime: Date
    var endTime: Date
    var selectedDays: [String]
    
    enum CodingKeys: String, CodingKey {
        case doctorId = "doctor_id"
        case priorBookingDays = "prior_booking_days"
        case startTime = "start_time"
        case endTime = "end_time"
        case selectedDays = "selected_days"
    }
    
    static let sample = DoctorSettings(doctorId: UUID(), priorBookingDays: 7, startTime: Date(), endTime: Date(), selectedDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])
    
    // Custom encoding to handle date formatting
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(doctorId, forKey: .doctorId)
        try container.encode(priorBookingDays, forKey: .priorBookingDays)
        try container.encode(DateFormatter.timeFormatter.string(from: startTime), forKey: .startTime)
        try container.encode(DateFormatter.timeFormatter.string(from: endTime), forKey: .endTime)
        try container.encode(selectedDays, forKey: .selectedDays)
    }
    
    // Custom decoding to handle date formatting
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        doctorId = try container.decode(UUID.self, forKey: .doctorId)
        priorBookingDays = try container.decode(Int.self, forKey: .priorBookingDays)
        
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        
        guard let startTime = DateFormatter.timeFormatter.date(from: startTimeString.prefix(8).description),
              let endTime = DateFormatter.timeFormatter.date(from: endTimeString.prefix(8).description) else {
            throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Invalid time format")
        }

        self.startTime = startTime
        self.endTime = endTime
        selectedDays = try container.decode([String].self, forKey: .selectedDays)
    }
    
    init(doctorId: UUID, priorBookingDays: Int, startTime: Date, endTime: Date, selectedDays: [String]) {
        self.doctorId = doctorId
        self.priorBookingDays = priorBookingDays
        self.startTime = startTime
        self.endTime = endTime
        self.selectedDays = selectedDays
    }
    
    // Returns default settings for a doctor
    static func getDefaultSettings(userId: UUID) -> DoctorSettings {
        let startTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        let endTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
        let selectedDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        
        return DoctorSettings(
            doctorId: userId,
            priorBookingDays: 7,
            startTime: startTime,
            endTime: endTime,
            selectedDays: selectedDays
        )
    }
    
    // Saves the doctor settings to the database
    func save() async throws {
        try await supabase.from("doctor_settings")
            .upsert(self)
            .eq("doctor_id", value: doctorId)
            .execute()
    }
    
    // Fetches the settings for a doctor from the database
    static func get(userId: UUID) async throws -> DoctorSettings {
        let response = try? await supabase.from("doctor_settings")
            .select()
            .eq("user_id", value: userId)
            .single()
            .execute()
        
        guard let response = response else {
            return getDefaultSettings(userId: userId)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            if let date = DateFormatter.timeFormatter.date(from: dateStr.prefix(8).description) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        
        return try decoder.decode(DoctorSettings.self, from: response.data)
    }
}
