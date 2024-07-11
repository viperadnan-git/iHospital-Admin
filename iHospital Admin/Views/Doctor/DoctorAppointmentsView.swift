//
//  DoctorAppointmentsView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 10/07/24.
//


import SwiftUI

struct DoctorAppointmentsView: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorViewModel
    
    @State private var isLoading = false
    @State private var appointments:[Appointment] = []
    @State private var searchText = ""
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Error fetching appointments")
    
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
                fetchAppointments()
            }
            .onAppear {
                fetchAppointments()
            }
        }.errorAlert(errorAlertMessage: errorAlertMessage)
            .navigationTitle("All Appointments")
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
    
    private func fetchAppointments() {
        guard let doctor = doctorDetailViewModel.doctor else { return }
        
        Task {
            do {
                let appointments = try await doctor.fetchAppointments()
                self.appointments = appointments
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    DoctorAppointmentsView()
        .environmentObject(DoctorViewModel())
}

