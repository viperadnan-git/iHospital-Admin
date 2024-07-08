//
//  DoctorSettingView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI

struct DoctorSettingView: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorDetailViewModel
    
    @State private var priorBookingDays = 7
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedDays: Set<String> = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @State private var fee = DEFAULT_DOCTOR_FEES
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Invalid Input")
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let priorBookingOptions = ["1 Week": 7, "2 Weeks": 14, "3 Weeks": 21, "4 Weeks": 28]
    
    var body: some View {
        HStack {
            DoctorDetailsColumn()
            
            Form {
                Section(header: Text("Consultancy Fees")) {
                    TextField("Fees", value: $fee, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Set Availability Time")) {
                    HStack {
                        VStack {
                            Text("Start Time")
                            TimePicker(selectedTime: $startTime)
                                .padding(.bottom)
                                .onChange(of: startTime) { newStartTime in
                                    if newStartTime >= endTime {
                                        endTime = Calendar.current.date(byAdding: .minute, value: 15, to: newStartTime) ?? endTime
                                    }
                                }
                        }
                        
                        VStack {
                            Text("End Time")
                            TimePicker(selectedTime: $endTime)
                                .padding(.bottom)
                                .onChange(of: endTime) { newEndTime in
                                    if newEndTime <= startTime {
                                        startTime = Calendar.current.date(byAdding: .minute, value: -15, to: newEndTime) ?? startTime
                                    }
                                }
                        }
                    }
                }
                
                Section(header: Text("Prior Booking Days")) {
                    Picker("Prior Booking Days", selection: $priorBookingDays) {
                        ForEach(priorBookingOptions.keys.sorted(), id: \.self) { key in
                            Text(key).tag(priorBookingOptions[key]!)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
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
            }
            .errorAlert(errorAlertMessage: errorAlertMessage)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Doctor Settings")
        .onAppear(perform: fetchSettings)
        .toolbar {
            Button(action: saveSettings) {
                Text("Save")
            }
        }
    }
    
    private func fetchSettings() {
        
        guard let settings = doctorDetailViewModel.doctor?.settings else {
            errorAlertMessage.message = "Failed to retrieve doctor settings."
            return
        }
        
        print(settings)
        
        priorBookingDays = settings.priorBookingDays
        startTime = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: settings.startTime),
                                          minute: Calendar.current.component(.minute, from: settings.startTime),
                                          second: 0,
                                          of: Date()) ?? Date()
        endTime = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: settings.endTime),
                                        minute: Calendar.current.component(.minute, from: settings.endTime),
                                        second: 0,
                                        of: Date()) ?? Date()
        selectedDays = Set(settings.selectedDays)
        fee = settings.fee
        
    }
    
    private func saveSettings() {
        Task {
            do {
                guard let settings = doctorDetailViewModel.doctor?.settings else {
                    errorAlertMessage.message = "Failed to retrieve doctor ID."
                    return
                }
                
                settings.priorBookingDays = priorBookingDays
                settings.startTime = startTime
                settings.endTime = endTime
                settings.selectedDays = Array(selectedDays)
                settings.fee = fee
                
                try await settings.save()
                
                errorAlertMessage.title = "Success"
                errorAlertMessage.message = "Settings saved successfully."
            } catch {
                errorAlertMessage.message = "Failed to save settings: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    DoctorSettingView().environmentObject(DoctorDetailViewModel())
}
