//
//  DoctorAppointmentsTable.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//

import SwiftUI

struct DoctorAppointmentsTable: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorDetailViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
            }
            
            
            Table(filteredAppointments) {
                TableColumn("Name", value: \.patient.name)
                TableColumn("Age") { appointment in
                    Text(appointment.patient.dateOfBirth.age)
                }
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
                TableColumn("Edit") { appointment in
                    Button(action: {
                        print("Edit button tapped for appointment \(appointment.id)")
                    }) {
                        Text("Edit")
                            .foregroundColor(.blue)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .refreshable {
                doctorDetailViewModel.fetchAppointments(for: Date())
            }
            .onAppear {
                doctorDetailViewModel.fetchAppointments(for: Date())
            }
        }
    }
    
    private var filteredAppointments: [Appointment] {
        if searchText.isEmpty {
            return doctorDetailViewModel.appointments
        } else {
            return doctorDetailViewModel.appointments.filter { appointment in
                appointment.patient.name.lowercased().contains(searchText.lowercased())
                || appointment.patient.dateOfBirth.age.lowercased().contains(searchText.lowercased())
                || appointment.patient.gender.id.lowercased().contains(searchText.lowercased())
                || appointment.date.timeString.lowercased().contains(searchText.lowercased())
                || appointment.patient.phoneNumber.string.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    DoctorAppointmentsTable()
        .environmentObject(DoctorDetailViewModel())
}
