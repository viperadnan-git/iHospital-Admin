//
//  AdminAppointmentsList.swift
//  iHospital Admin
//
//  Created by Aditya on 04/07/24.
//

import SwiftUI

struct AdminAppointmentsTable: View {
    
    @State private var selectedDate = Date()
    @State private var searchText = ""
    @State private var appointments: [Appointment] = []
    @State private var isLoading = false
    
    @State private var sortOrder = [KeyPathComparator(\Appointment.date, order: .forward)]

    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                Spacer()
                ProgressView().scaleEffect(2)
                Spacer()
            } else if filteredAppointments.isEmpty {
                Text("No appointments found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color(.systemGray))
            } else {
                Table(filteredAppointments, sortOrder: $sortOrder) {
                    TableColumn("Name", value: \.patient.name)
                    TableColumn("Gender", value: \.patient.gender.id.capitalized)
                    TableColumn("Phone No.", value: \.patient.phoneNumber.string)
                    TableColumn("Time", value:\.date) { appointment in
                        Text(appointment.date.dateTimeString)
                    }
                }
                .frame(maxWidth: .infinity)
                .refreshable {
                    fetchAppointments(showLoader: false, force: true)
                }
                .onChange(of: sortOrder) { neworder in
                    appointments.sort(using: neworder)
                }
            }
        }
        .navigationTitle("Appointments")
        .searchable(text: $searchText)
        .onAppear {
            fetchAppointments()
        }
    }

    private var filteredAppointments: [Appointment] {
        if searchText.isEmpty {
            return appointments
        } else {
            return appointments.filter { appointment in
                appointment.patient.name.lowercased().contains(searchText.lowercased())
                || appointment.patient.gender.id.lowercased().contains(searchText.lowercased())
                || appointment.date.dateTimeString.lowercased().contains(searchText.lowercased())
                || appointment.patient.phoneNumber.string.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func fetchAppointments(showLoader: Bool = true, force: Bool = false) {
        Task {
            isLoading = showLoader
            defer {
                isLoading = false
            }
            
            do {
                let appointments = try await Appointment.fetchAppointments(force: force)
                self.appointments = appointments
            } catch {
                print("Error fetching appointments: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    AdminAppointmentsTable()
}
