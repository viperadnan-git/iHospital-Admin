//
//  Dashboard.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

let onepatient = Patient(id: UUID(), name: "Adnan", age: 12, gender: .male)

let secondpatient = Patient(id: UUID(), name: "Shweta", age: 12, gender: .male)

let thirdpatient = Patient(id: UUID(), name: "Vicky", age: 12, gender: .male)

let oneDoctor = Doctor(id: UUID(), name: "Harry Singh", dateOfBirth: Date(), gender: .male, phoneNumber: "+91 XXXXXXXXXX", email: "harry@gmail.com", qualification: "MBBS,MS", experience: Date())



let totalDoctors = [
    Doctor(id: UUID(), name: "Alex CArry", dateOfBirth: Date(), gender: .male, phoneNumber: "+91 XXXXXXXXXX", email: "alex@gmail.com", qualification: "MBBS,MS", experience: Date()),
    Doctor(id: UUID(), name: "Harry Singh", dateOfBirth: Date(), gender: .male, phoneNumber: "+91 XXXXXXXXXX", email: "harry@gmail.com", qualification: "MBBS,MS", experience: Date()),
    Doctor(id: UUID(), name: "Shubham Singh", dateOfBirth: Date(), gender: .male, phoneNumber: "+91 XXXXXXXXXX", email: "shubham@gmail.com", qualification: "MBBS,MS", experience: Date()),
    Doctor(id: UUID(), name: "Neeta Singh", dateOfBirth: Date(), gender: .female, phoneNumber: "+91 XXXXXXXXXX", email: "neeta@gmail.com", qualification: "MBBS,MS", experience: Date())
]

var totalAppointments = [
    Appointment(id: UUID(), patient: onepatient, phoneNumber: "+91 XXXXXXXXXX", doctor: oneDoctor, appointmentTime: Date()),
    Appointment(id: UUID(), patient: secondpatient, phoneNumber: "+91 XXXXXXXXXX", doctor: oneDoctor, appointmentTime: Date()),
    Appointment(id: UUID(), patient: thirdpatient, phoneNumber: "+91 XXXXXXXXXX", doctor: oneDoctor, appointmentTime: Date()),
    Appointment(id: UUID(), patient: onepatient, phoneNumber: "+91 XXXXXXXXXX", doctor: oneDoctor, appointmentTime: Date()),
    Appointment(id: UUID(), patient: secondpatient, phoneNumber: "+91 XXXXXXXXXX", doctor: oneDoctor, appointmentTime: Date())
]

var totalPatients = [
    Patient(id: UUID(), name: "Adnan", age: 12, gender: .male),
    Patient(id: UUID(), name: "Shweta", age: 12, gender: .male),
    Patient(id: UUID(), name: "Vicky", age: 12, gender: .male)
]

struct AdminDashboardView: View {
    @State private var searchText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 30){
                    VStack(alignment:.leading,spacing: 15) {
                        Text("Today's Overview")
                            .font(.title)
                            .padding(.top)
                            .padding(.leading,30)

                        HStack(spacing: 20) {
                            OverviewCard(title: "\(totalAppointments.count)", subtitle: "Appointments", color: .pink)
                                .frame(maxWidth: .infinity)
                            OverviewCard(title: "\(totalPatients.count)", subtitle: "New Patients", color: .purple)
                                .frame(maxWidth: .infinity)
                        }
                        .padding([.leading,.trailing],30)
                        .frame(maxWidth: .infinity)

                        HStack(spacing: 20) {
                            OverviewCard(title: "\(totalDoctors.count)", subtitle: "Available Doctors", color: .yellow)
                            OverviewCard(title: "13", subtitle: "Lab Tests", color: .blue)
                        }
                        .padding(.top,0)
                        .padding([.leading,.trailing],30)
                        .padding(.bottom,20)
                        .padding(.top,14)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.dashboard)
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Revenue")
                            .font(.title)
                            .padding(.top)
                            .padding(.leading,30)
                        
                        VStack(){
                            OverviewCard(title: "$XYZ", subtitle: "Total Revenue", color: .purple)
                                .padding([.leading,.trailing],30)
                                .padding(.top,10)

                            OverviewCard(title: "$YYY", subtitle: "Total Revenue", color: .purple)
                                .padding([.leading,.trailing],30)
                                .padding(.bottom,25)
                                .padding(.top,10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.dashboard)
                    .cornerRadius(12)
                }

                VStack(alignment: .leading){
                    Text("Today's Appointments")
                        .padding([.top,.leading,.trailing],20)
                        .font(.title3)
                        .bold()

                    SearchBar(searchText: $searchText)
                    
                    AppointmentsList(searchText: $searchText)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding()
                }
                .background(Color.card)
                .cornerRadius(12)
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}

struct OverviewCard: View {
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
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


//UI for search bar
struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)

                TextField("Search Patients", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .background(Color.white)
            }
            .padding([.leading, .trailing])
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding([.leading, .trailing])
    }
}
//to display all the Appointment Lists
struct AppointmentsList: View {
    @Binding var searchText: String

    var body: some View {
        LazyVStack {
            
            HStack{
                Text("Patient ID").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Patient Name").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Mobile Number").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Appointment Time").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Doctor").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Status").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
            }
            .background(Color.white)
            .padding()
            
            ForEach(filteredAppointments()) { appointment in
                AppointmentRow(appointment: appointment)
            }
            .frame(maxWidth: .infinity)
        }
    }

    func filteredAppointments() -> [Appointment] {
        if searchText.isEmpty {
            return totalAppointments
        } else {
            return totalAppointments.filter { $0.patient.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
//To make One Appointment List
struct AppointmentRow: View {
    var appointment: Appointment

    var body: some View {
        
        HStack(spacing:20) {
            Text("\(appointment.patient.id)")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(appointment.patient.name)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,40)
            Text("\(appointment.phoneNumber)")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(formattedTime(date: appointment.appointmentTime))")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(appointment.doctor.name)")
                .frame(maxWidth: .infinity, alignment: .leading)
            StatusIndicator(status: "Upcoming")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding([.leading, .trailing], 10)
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
