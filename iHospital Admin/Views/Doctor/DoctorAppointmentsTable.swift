//
//  DoctorAppointmentsTable.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//

import SwiftUI

struct DoctorAppointmentsTable: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
            }
            
            
            Table(filteredAppointments) {
                TableColumn("Name") { appointment in
                    Text(appointment.patient.name)
                        .foregroundStyle((appointment.status == AppointmentStatus.completed) ? Color(.systemGray6) : Color(.label))
                }
                TableColumn("Age", value: \.patient.dateOfBirth.age)
                TableColumn("Gender", value: \.patient.gender.id.capitalized)
                TableColumn("Phone No.") { appointment in
                    Text(appointment.patient.phoneNumber.string)
                }
                TableColumn("Time") { appointment in
                    Text(appointment.date.timeString)
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
        .environmentObject(DoctorViewModel())
}
