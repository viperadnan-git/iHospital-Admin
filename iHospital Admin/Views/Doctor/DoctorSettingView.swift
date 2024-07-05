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
    @State private var errorTitle: String? = "Invalid Input"
    @State private var errorMessage: String?
    
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
                    priorBookingDays: priorBookingDays,
                    startTime: startTime,
                    endTime: endTime,
                    selectedDays: Array(selectedDays),
                    fee: fee
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
