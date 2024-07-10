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

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if filteredAppointments.isEmpty {
                Text("No appointments found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color(.systemGray))
            } else {
                Table(filteredAppointments) {
                    TableColumn("Name", value: \.patient.name)
                    TableColumn("Gender", value: \.patient.gender.id.capitalized)
                    TableColumn("Phone No.") { appointment in
                        Text(appointment.patient.phoneNumber.string)
                    }
                    TableColumn("Time") { appointment in
                        Text(appointment.date.timeString)
                    }
                    TableColumn("Date") { appointment in
                        Text(appointment.date.dateString)
                    }
                }
                .frame(maxWidth: .infinity)
                .refreshable {
                    fetchAppointments(false)
                }
            }
        }
        .navigationTitle("Appointments")
        .searchable(text: $searchText)
        .onAppear {
            fetchAppointments(true)
        }
    }

    private var filteredAppointments: [Appointment] {
        if searchText.isEmpty {
            return appointments
        } else {
            return appointments.filter { appointment in
                appointment.patient.name.lowercased().contains(searchText.lowercased())
                || appointment.patient.dateOfBirth.age.lowercased().contains(searchText.lowercased())
                || appointment.patient.gender.id.lowercased().contains(searchText.lowercased())
                || appointment.date.timeString.lowercased().contains(searchText.lowercased())
                || appointment.patient.phoneNumber.string.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func fetchAppointments(_ showIndicator: Bool = true) {
        Task {
            isLoading = showIndicator
            do {
                let appointments = try await Appointment.fetchAppointments()
                self.appointments = appointments
            } catch {
                print("Error fetching appointments: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
}

#Preview {
    AdminAppointmentsTable()
}
