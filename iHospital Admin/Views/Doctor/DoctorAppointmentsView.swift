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
    
    @State private var sortOrder = [KeyPathComparator(\Appointment.date, order: .forward)]
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Error fetching appointments")
    
    
    
    var body: some View {
        VStack {
          
            Table(filteredAppointments, sortOrder: $sortOrder) {
                TableColumn("Name", value: \.patient.name)
                TableColumn("Age", value: \.patient.dateOfBirth.ago)
                TableColumn("Gender", value: \.patient.gender.id.capitalized)
                TableColumn("Phone No.", value: \.patient.phoneNumber.string)
                
                TableColumn("Time", value:\.date) { appointment in
                    Text(appointment.date.dateTimeString)
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
            .onChange(of: sortOrder) { neworder in
                appointments.sort(using: neworder)
            }
        }.errorAlert(errorAlertMessage: errorAlertMessage)
            .navigationTitle("All Appointments")
            .searchable(text: $searchText)
    }
    
    private var filteredAppointments: [Appointment] {
        if searchText.isEmpty {
            return appointments
        } else {
            return appointments.filter { appointment in
                appointment.patient.name.lowercased().contains(searchText.lowercased())
                || appointment.patient.dateOfBirth.ago.lowercased().contains(searchText.lowercased())
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

