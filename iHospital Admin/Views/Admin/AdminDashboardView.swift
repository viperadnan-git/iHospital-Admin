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
    @State private var appointments: [Appointment] = []
    @State private var isLoading = false
    @StateObject var patientViewModel = PatientViewModel()
    @State private var sortOrder = [KeyPathComparator(\Appointment.date, order: .forward)]
    
    var body: some View {
//        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 30){
                    VStack(alignment:.leading,spacing: 15) {
                        Text("Today's Overview")
                            .padding([.top,.trailing],20)
                            .font(.title3)
                            .bold()

                        HStack(spacing: 20) {
                            OverviewCard(title: .constant(appointments.count.string), subtitle: "Appointments", color: .pink)
                                .frame(maxWidth: .infinity)
                            OverviewCard(title: .constant(patientViewModel.patients.count.string), subtitle: "New Patients", color: .purple)
                                .frame(maxWidth: .infinity)
                        }
                        .padding([.trailing],10)
                        .frame(maxWidth: .infinity)

                        HStack(spacing: 20) {
                            OverviewCard(title: .constant("7"), subtitle: "Available Doctors", color: .yellow)
                            OverviewCard(title: .constant("13"), subtitle: "Lab Tests", color: .blue)
                        }
                        .padding(.top,0)
                        .padding(.trailing,10)
                        .padding(.bottom,20)
                        .padding(.top,14)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Revenue")
                            .padding([.top,.trailing],20)
                            .font(.title3)
                            .bold()
                        
                        VStack(){
                            OverviewCard(title: .constant("XYZ"), subtitle: "Total Revenue", color: .purple)
                                .padding([.trailing],30)
                                .padding(.bottom,15)

//                                .padding(.top,)

                            OverviewCard(title: .constant("XYZ"), subtitle: "Total Revenue", color: .purple)
                                .padding([.trailing],30)
                                .padding(.bottom,25)
                                .padding(.top,5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                Divider()
                
                VStack(alignment: .leading){
                    Text("Today's Appointments")
                        .padding([.top,.trailing],20)
                        .padding(.leading,12)
                        .font(.title3)
                        .bold()
                    
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .scaleEffect(2.0)
                    }
                    
                    else{
                        Table(appointments,sortOrder: $sortOrder){
                            TableColumn("Patient Name", value: \.patient.firstName)
                            TableColumn("Mobile Number", value: \.patient.phoneNumber.string)
                            TableColumn("Time", value: \.date.dateTimeString)
                            TableColumn("Doctor", value: \.doctor.firstName)
                            
                            TableColumn("Status") { appointment in
                                AppointmentStatusIndicator(status: appointment.status)
                            }
                            
                        }
                        .onChange(of: sortOrder) { newOrder in
                            appointments.sort(using: newOrder)
                        }
                    }
                    
                }

                
            }
            .padding()
            .navigationTitle("Dashboard")
            .onAppear(perform: fetchAppointments)
//        }
    }
    
    func fetchAppointments() {
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let appointments = try await Appointment.fetchAppointments(forDate: Date())
                self.appointments = appointments.sorted(by: { $0.date < $1.date })
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
    @Binding var appointments: [Appointment]

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
            
            ForEach(appointments, id: \.id) { appointment in
                AppointmentRow(appointment: appointment)
                Divider()
            }
            .frame(maxWidth: .infinity)
            .padding(.leading)
            .padding(.trailing)
        }
    }
}
//To make One Appointment List
struct AppointmentRow: View {
    var appointment: Appointment

    var body: some View {
            HStack {
                Text("\(appointment.patient.firstName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(appointment.patient.phoneNumber))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(appointment.date.timeString)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(appointment.doctor.firstName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                AppointmentStatusIndicator(status: appointment.status)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
            }
            // TODO: use auto colors
            .foregroundColor(Color(.label))
    }

    func formattedTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AppointmentStatusIndicator: View {
    let status: AppointmentStatus

    var body: some View {
        HStack {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
            Text(status.rawValue.capitalized)
                .font(.footnote)
        }
    }
}

#Preview {
    AdminDashboardView()
}
