//
//  DoctorSettingView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI

struct DoctorSettingView: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorDetailViewModel
    @State private var availabilityStartDate = Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 10))!
    @State private var availabilityEndDate = Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 10))!
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedDays: Set<String> = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @State private var errorTitle: String? = "Invalid Input"
    @State private var errorMessage: String?
    
    var daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        HStack {
            DoctorDetailsColumn()
            
            Form {
                Section(header: Text("Set Availability Date")) {
                    DatePicker("Availability Start Date", selection: $availabilityStartDate, displayedComponents: .date)
                    
                    DatePicker("Availability End Date", selection: $availabilityEndDate, displayedComponents: .date)
                }
                
                Section(header: Text("Set Availability Time")) {
                    HStack {
                        VStack {
                            Text("Start Time")
                            TimePicker(selectedTime: $startTime)
                                .padding(.bottom)
                        }
                        
                        VStack {
                            Text("End Time")
                            TimePicker(selectedTime: $endTime)
                                .padding(.bottom)
                        }
                    }
                }
                
                Section(header: Text("Select Days of the Week")) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Toggle(day, isOn: Binding<Bool>(
                            get: { selectedDays.contains(day) },
                            set: { isSelected in
                                if isSelected {
                                    selectedDays.insert(day)
                                } else {
                                    selectedDays.remove(day)
                                }
                            }
                        ))
                    }
                }
                
                Button(action: saveSettings) {
                    Text("Save Settings")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .errorAlert(title: $errorTitle, message: $errorMessage)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Doctor Settings")
        .onAppear(perform: fetchSettings)
    }
    
    private func fetchSettings() {
        Task {
            do {
                guard let userId = doctorDetailViewModel.doctor?.userId else {
                    errorMessage = "Failed to retrieve doctor ID."
                    return
                }
                
                let settings = try await DoctorSettings.get(userId: userId)
                availabilityStartDate = settings.availabilityStartDate
                availabilityEndDate = settings.availabilityEndDate
                startTime = settings.startTime
                endTime = settings.endTime
                selectedDays = Set(settings.selectedDays)
            } catch {
                errorMessage = "Failed to fetch settings: \(error.localizedDescription)"
            }
        }
    }
    
    private func saveSettings() {
        Task {
            do {
                guard let userId = doctorDetailViewModel.doctor?.userId else {
                    errorMessage = "Failed to retrieve doctor ID."
                    return
                }
                
                try await DoctorSettings.save(
                    userId: userId,
                    availabilityStartDate: availabilityStartDate,
                    availabilityEndDate: availabilityEndDate,
                    startTime: startTime,
                    endTime: endTime,
                    selectedDays: Array(selectedDays)
                )
                errorMessage = "Settings saved successfully."
                errorTitle = "Success"
            } catch {
                errorMessage = "Failed to save settings: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    DoctorSettingView().environmentObject(DoctorDetailViewModel())
}
