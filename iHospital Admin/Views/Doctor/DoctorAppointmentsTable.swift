//
//  DoctorAppointmentsTable.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//

import SwiftUI

struct DoctorAppointmentsTable: View {
    @EnvironmentObject var doctorViewModel: DoctorViewModel
    
    @State private var searchText = ""
    @State private var sortOrder = [KeyPathComparator(\Appointment.date, order: .forward)]
    
    @State private var appointments: [Appointment] = []
    
    @State private var showPopover = false
    @State private var popoverMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .accessibilityLabel("Search Bar")
                    .accessibilityHint("Search for appointments by patient name, age, gender, time, or phone number")
            }
            
            Table(appointments, sortOrder: $sortOrder) {
                TableColumn("Name", value: \.patient.name)
                TableColumn("Age", value: \.patient.dateOfBirth.ago)
                TableColumn("Gender", value: \.patient.gender.id.capitalized)
                TableColumn("Phone No.", value: \.patient.phoneNumber.string)
                TableColumn("Time", value: \.date) { appointment in
                    Text(appointment.date.timeString)
                        .accessibilityLabel("Appointment Time")
                }
                TableColumn("Status") { appointment in
                    AppointmentStatusIndicator(status: appointment.status)
                        .accessibilityLabel("Appointment Status")
                }
                TableColumn("Edit") { appointment in
                    EditButton(appointment: appointment)
                        .accessibilityLabel("Edit Appointment")
                }
            }
            .frame(maxWidth: .infinity)
            .onChange(of: sortOrder) { newOrder in
                refresh()
            }
            .refreshable {
                doctorViewModel.fetchAppointments(for: Date())
            }
            .onAppear {
                refresh()
            }
            .onChange(of: doctorViewModel.appointments) { _ in
                refresh()
            }
            .onChange(of: searchText) { _ in
                refresh()
            }
            .popover(isPresented: $showPopover) {
                Text(popoverMessage)
                    .padding()
                    .accessibilityLabel(popoverMessage)
            }
        }
        .accessibilityElement(children: .combine)
        .navigationTitle("Doctor Appointments")
        .accessibilityAddTraits(.isHeader)
    }
    
    func refresh() {
        if searchText.isEmpty {
            appointments = doctorViewModel.appointments.sorted(using: sortOrder)
        } else {
            appointments = doctorViewModel.appointments.filter { appointment in
                appointment.patient.name.lowercased().contains(searchText.lowercased())
                || appointment.patient.dateOfBirth.ago.lowercased().contains(searchText.lowercased())
                || appointment.patient.gender.id.lowercased().contains(searchText.lowercased())
                || appointment.date.timeString.lowercased().contains(searchText.lowercased())
                || appointment.patient.phoneNumber.string.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct EditButton: View {
    @State private var showPopover = false
    @State private var popoverMessage = ""
    var appointment: Appointment
    
    var body: some View {
        let canEdit = Date().addingTimeInterval(4 * 60 * 60) < appointment.date
        
        Menu {
            Button("Reschedule Appointment", action: rescheduleAppointment)
                .disabled(!canEdit)
                .accessibilityLabel("Reschedule Appointment")
            Button("Cancel Appointment", action: cancelAppointment)
                .disabled(!canEdit)
                .accessibilityLabel("Cancel Appointment")
        } label: {
            Button(action: {
                if canEdit {
                    // No action needed, Menu will handle it
                } else {
                    popoverMessage = "Editing is only available before 4 hours of the appointment."
                    showPopover = true
                }
            }) {
                Image(systemName: "pencil.circle")
                    .foregroundColor(canEdit ? .blue : .gray)
                    .accessibilityLabel(canEdit ? "Edit Appointment" : "Edit not available")
                    .accessibilityHint(canEdit ? "" : "Editing is only available before 4 hours of the appointment.")
            }
            .popover(isPresented: $showPopover) {
                Text(popoverMessage)
                    .padding()
                    .accessibilityLabel(popoverMessage)
            }
        }
        .disabled(!canEdit)
    }
    
    func rescheduleAppointment() {
        // Implement reschedule functionality here
    }
    
    func cancelAppointment() {
        // Implement cancel functionality here
    }
}

#Preview {
    DoctorAppointmentsTable()
        .environmentObject(DoctorViewModel())
}
