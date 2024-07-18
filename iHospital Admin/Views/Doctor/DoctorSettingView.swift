//
//  DoctorSettingView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI

struct DoctorSettingView: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorViewModel
    
    @State private var priorBookingDays = 7
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedDays: Set<String> = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Invalid Input")
    
    @State private var isSaving = false
    @State private var feeError: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fee
    }
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let priorBookingOptions = ["1 Week": 7, "2 Weeks": 14, "3 Weeks": 21, "4 Weeks": 28]
    
    var body: some View {
        HStack {
            DoctorDetailsColumn()
            
            Form {
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
                
                Section(header: Text("Prior Booking")) {
                    Picker("Prior Booking Days", selection: $priorBookingDays) {
                        ForEach(priorBookingOptions.keys.sorted(), id: \.self) { key in
                            Text(key).tag(priorBookingOptions[key]!)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }.listRowInsets(.init(top: 0, leading: 7, bottom: 0, trailing: 7))
                
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
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Doctor Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchSettings)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: saveSettings) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Save")
                    }
                }
                .disabled(isSaving)
            }
        }.errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    private func fetchSettings() {
        guard let settings = doctorDetailViewModel.doctor?.settings else {
            errorAlertMessage.message = "Failed to retrieve doctor settings."
            return
        }
        
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
    }
    
    private func saveSettings() {
        guard feeError == nil else {
            errorAlertMessage.message = "Please correct the errors before saving."
            return
        }
        
        isSaving = true
        Task {
            do {
                guard let settings = doctorDetailViewModel.doctor?.settings else {
                    errorAlertMessage.message = "Failed to retrieve doctor ID."
                    isSaving = false
                    return
                }
                
                settings.priorBookingDays = priorBookingDays
                settings.startTime = startTime
                settings.endTime = endTime
                settings.selectedDays = Array(selectedDays)
                
                try await settings.save()
                
                errorAlertMessage.title = "Success"
                errorAlertMessage.message = "Settings saved successfully."
            } catch {
                errorAlertMessage.message = "Failed to save settings: \(error.localizedDescription)"
            }
            isSaving = false
        }
    }
}

#Preview {
    DoctorSettingView().environmentObject(DoctorViewModel())
}
