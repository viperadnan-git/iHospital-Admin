//
//  TimePicker.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI

struct TimePicker: View {
    @Binding var selectedTime: Date
    
    var body: some View {
        Picker("Time", selection: $selectedTime) {
            ForEach(timeSlots(), id: \.self) { time in
                Text(time, formatter: DateFormatter.timeFormatterWithMedian).tag(time)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(height: 150)
        .clipped()
    }
    
    private func timeSlots() -> [Date] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        return stride(from: startOfDay, to: startOfDay.addingTimeInterval(24 * 60 * 60), by: 15 * 60)
            .map { $0 }
    }
}
