//
//  DoctorSettings.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation

struct DoctorSettings: Codable {
    let userId: UUID
    let availabilityStartDate: Date
    let availabilityEndDate: Date
    let startTime: Date
    let endTime: Date
    let selectedDays: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case availabilityStartDate = "availability_start_date"
        case availabilityEndDate = "availability_end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case selectedDays = "selected_days"
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(availabilityStartDate, forKey: .availabilityStartDate)
        try container.encode(availabilityEndDate, forKey: .availabilityEndDate)
        try container.encode(DoctorSettings.timeFormatter.string(from: startTime), forKey: .startTime)
        try container.encode(DoctorSettings.timeFormatter.string(from: endTime), forKey: .endTime)
        try container.encode(selectedDays, forKey: .selectedDays)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(UUID.self, forKey: .userId)
        availabilityStartDate = try container.decode(Date.self, forKey: .availabilityStartDate)
        availabilityEndDate = try container.decode(Date.self, forKey: .availabilityEndDate)
        
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        
        guard let startTime = DoctorSettings.timeFormatter.date(from: startTimeString),
              let endTime = DoctorSettings.timeFormatter.date(from: endTimeString) else {
            throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Invalid time format")
        }
        
        self.startTime = startTime
        self.endTime = endTime
        selectedDays = try container.decode([String].self, forKey: .selectedDays)
    }
    
    init(userId: UUID, availabilityStartDate: Date, availabilityEndDate: Date, startTime: Date, endTime: Date, selectedDays: [String]) {
        self.userId = userId
        self.availabilityStartDate = availabilityStartDate
        self.availabilityEndDate = availabilityEndDate
        self.startTime = startTime
        self.endTime = endTime
        self.selectedDays = selectedDays
    }
    
    static func save(userId: UUID, availabilityStartDate: Date, availabilityEndDate: Date, startTime: Date, endTime: Date, selectedDays: [String]) async throws {
        let settings = DoctorSettings(
            userId: userId,
            availabilityStartDate: availabilityStartDate,
            availabilityEndDate: availabilityEndDate,
            startTime: startTime,
            endTime: endTime,
            selectedDays: selectedDays
        )
        
        try await supabase.from("doctor_settings")
            .upsert(settings)
            .eq("user_id", value: userId)
            .execute()
    }
    
    static func get(userId: UUID) async throws -> DoctorSettings {
        let response = try? await supabase.from("doctor_settings")
            .select()
            .eq("user_id", value: userId)
            .single()
            .execute()
        
        guard let response = response else {
            let startDate = Date()
            let endDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate)!
            let startTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: startDate)!
            let endTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: startDate)!
            let selectedDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
            
            return DoctorSettings(
                userId: userId,
                availabilityStartDate: startDate,
                availabilityEndDate: endDate,
                startTime: startTime,
                endTime: endTime,
                selectedDays: selectedDays
            )
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let settings = try decoder.decode(DoctorSettings.self, from: response.data)
        
        print(settings)
        return settings
    }
}

