//
//  Dashboard.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

let totalDoctors = [
    Doctor.sample, Doctor.sample, Doctor.sample, Doctor.sample
]

var totalAppointments = [
    Appointment.sample, Appointment.sample, Appointment.sample, Appointment.sample
]

var totalPatients = [
    Patient.sample,
    Patient.sample,
    Patient.sample,
    Patient.sample
]

struct AdminDashboardView: View {
    @State private var searchText = ""

    @State private var appointmentsCount: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 30){
                    VStack(alignment:.leading,spacing: 15) {
                        Text("Today's Overview")
                            .padding([.top,.leading,.trailing],20)
                            .font(.title3)
                            .bold()

                        HStack(spacing: 20) {
                            OverviewCard(title: $appointmentsCount, subtitle: "Appointments", color: .pink)
                                .frame(maxWidth: .infinity)
                            OverviewCard(title: .constant("5"), subtitle: "New Patients", color: .purple)
                                .frame(maxWidth: .infinity)
                        }
                        .padding([.leading,.trailing],30)
                        .frame(maxWidth: .infinity)

                        HStack(spacing: 20) {
                            OverviewCard(title: .constant("7"), subtitle: "Available Doctors", color: .yellow)
                            OverviewCard(title: .constant("13"), subtitle: "Lab Tests", color: .blue)
                        }
                        .padding(.top,0)
                        .padding([.leading,.trailing],30)
                        .padding(.bottom,20)
                        .padding(.top,14)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Revenue")
                            .padding([.top,.leading,.trailing],20)
                            .font(.title3)
                            .bold()
                        
                        VStack(){
                            OverviewCard(title: .constant("XYZ"), subtitle: "Total Revenue", color: .purple)
                                .padding([.leading,.trailing],30)
                                .padding(.top,10)

                            OverviewCard(title: .constant("XYZ"), subtitle: "Total Revenue", color: .purple)
                                .padding([.leading,.trailing],30)
                                .padding(.bottom,25)
                                .padding(.top,10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                
                Divider()
                
                VStack(alignment: .leading){
                    Text("Today's Appointments")
                        .padding([.top,.leading,.trailing],20)
                        .font(.title3)
                        .bold()
                    
                    AdminAppointmentsList(searchText: $searchText)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
            }
            .padding()
            .navigationTitle("Dashboard")
            .onAppear(perform: fetchAppointments)
        }
    }
    
    func fetchAppointments() {
        Task {
            do {
                let appointments = try await Appointment.fetchAppointments()
                self.appointmentsCount = String(appointments.count)
            } catch {
                print("Error fetching appointments: \(error.localizedDescription)")
            }
        }
    }
}

struct OverviewCard: View {
    @Binding var title: String?
    let subtitle: String
    let color: Color

    var body: some View {
        VStack {
            if title != nil {
                Text(title!)
                    .font(.largeTitle)
                    .bold()
            } else {
                ProgressView()
                    .padding()
            }
           
            Text(subtitle)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(color)
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}



//to display all the Appointment Lists
struct AdminAppointmentsList: View {
    @Binding var searchText: String
    @State private var appointments: [Appointment] = []

    var body: some View {
        VStack {
            HStack {
                Text("Patient Name").frame(maxWidth: .infinity,alignment: .leading)
                Text("Mobile Number").frame(maxWidth: .infinity,alignment: .leading)
                Text("Appointment Time").frame(maxWidth: .infinity,alignment: .leading)
                Text("Doctor").frame(maxWidth: .infinity,alignment: .leading)
                Text("Status").frame(maxWidth: .infinity,alignment: .leading)
                   
            } .font(.caption)
                .textCase(.uppercase)
                .foregroundColor(Color(.systemGray))
                .bold()
                .frame(maxWidth: .infinity,alignment: .leading)
            .padding()
            
            ForEach(filteredAppointments(), id: \.id) { appointment in
                AppointmentRow(appointment: appointment)
                Divider()
            }
            .frame(maxWidth: .infinity)
            .padding(.leading,20)
        }
        .onAppear(perform: fetchAppointments)
    }

    func filteredAppointments() -> [Appointment] {
        if searchText.isEmpty {
            return appointments
        } else {
            return appointments.filter { $0.patient.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func fetchAppointments() {
        Task {
            do {
                let appointments = try await Appointment.fetchAppointments()
                self.appointments = appointments
            } catch {
                print("Error fetching appointments: \(error.localizedDescription)")
            }
        }
    }
}
//To make One Appointment List
struct AppointmentRow: View {
    var appointment: Appointment

    var body: some View {
        NavigationLink(destination: AdminPatientDetailsView(patient: appointment.patient)) {
            HStack {
                Text("\(appointment.patient.firstName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(appointment.patient.phoneNumber))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(formattedTime(date: appointment.createdAt))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(appointment.doctor.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                StatusIndicator(status: "Upcoming")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            // TODO: use auto colors
            .foregroundColor(Color(.label))
        }
    }

    func formattedTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatusIndicator: View {
    let status: String

    var body: some View {
        HStack {
            Circle()
                .fill(statusColor(status: status))
                .frame(width: 10, height: 10)
            Text(status)
                .font(.footnote)
        }
    }

    func statusColor(status: String) -> Color {
        switch status {
        case "Upcoming":
            return .green
        case "Completed":
            return .blue
        case "Cancelled":
            return .red
        case "Pending":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    AdminDashboardView()
}
