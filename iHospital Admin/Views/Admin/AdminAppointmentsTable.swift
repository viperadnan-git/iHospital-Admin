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
                CenterSpinner()
                    .accessibility(label: Text("Loading appointments"))
            } else if filteredAppointments.isEmpty {
                Text("No appointments found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color(.systemGray))
                    .accessibility(label: Text("No appointments found"))
            } else {
                Table(filteredAppointments, sortOrder: $sortOrder) {
                    TableColumn("Name", value: \.patient.name)
                    TableColumn("Gender", value: \.patient.gender.id.capitalized)
                    TableColumn("Phone No.", value: \.patient.phoneNumber.string)
                    TableColumn("Time", value: \.date) { appointment in
                        Text(appointment.date.dateTimeString)
                            .accessibility(label: Text("Appointment Time"))
                            .accessibility(value: Text(appointment.date.dateTimeString))
                    }
                }
                .frame(maxWidth: .infinity)
                .refreshable {
                    fetchAppointments(showLoader: false, force: true)
                }
                .onChange(of: sortOrder) { newOrder in
                    appointments.sort(using: newOrder)
                }
                .accessibilityElement(children: .contain)
            }
        }
        .navigationTitle("Appointments")
        .searchable(text: $searchText)
        .onAppear {
            fetchAppointments()
        }
        .accessibility(label: Text("Appointments Table"))
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
