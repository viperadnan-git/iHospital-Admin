//
//  AdminDashboardView.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

struct AdminDashboardView: View {
    @State private var appointments: [Appointment] = []
    @State private var isLoading = false
    @State private var doctorCount: Int = 0
    @State private var labTestCount: Int = 0
    @State private var todayRevenue: Int = 0
    @State private var totalRevenue: Int = 0
    @StateObject var patientViewModel = PatientViewModel()
    @State private var sortOrder = [KeyPathComparator(\Appointment.date, order: .forward)]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Today's Overview")
                            .padding([.top, .trailing], 20)
                            .font(.title3)
                            .bold()
                        
                        HStack(spacing: 20) {
                            OverviewCard(title: .constant(appointments.count.string), subtitle: "Appointments", color: .pink)
                                .frame(maxWidth: .infinity)
                                .accessibilityElement(children: .combine)
                                .accessibility(label: Text("Appointments"))
                                .accessibility(value: Text("\(appointments.count)"))
                            
                            OverviewCard(title: .constant(patientViewModel.patients.count.string), subtitle: "Patients", color: .purple)
                                .frame(maxWidth: .infinity)
                                .accessibilityElement(children: .combine)
                                .accessibility(label: Text("Patients"))
                                .accessibility(value: Text("\(patientViewModel.patients.count)"))
                        }
                        .padding([.trailing], 10)
                        .frame(maxWidth: .infinity)
                        
                        HStack(spacing: 20) {
                            OverviewCard(title: .constant(doctorCount.string), subtitle: "Doctors", color: .blue)
                                .accessibilityElement(children: .combine)
                                .accessibility(label: Text("Doctors"))
                                .accessibility(value: Text("\(doctorCount)"))
                            
                            OverviewCard(title: .constant(labTestCount.string), subtitle: "Lab Tests", color: .green)
                                .accessibilityElement(children: .combine)
                                .accessibility(label: Text("Lab Tests"))
                                .accessibility(value: Text("\(labTestCount)"))
                        }
                        .padding(.top, 0)
                        .padding(.trailing, 10)
                        .padding(.bottom, 20)
                        .padding(.top, 14)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Revenue")
                            .padding([.top, .trailing], 20)
                            .font(.title3)
                            .bold()
                        
                        VStack() {
                            OverviewCard(title: .constant(todayRevenue.currency), subtitle: "Today Revenue", color: .cyan)
                                .padding([.trailing], 30)
                                .padding(.bottom, 15)
                                .accessibilityElement(children: .combine)
                                .accessibility(label: Text("Today's Revenue"))
                                .accessibility(value: Text(todayRevenue.currency))
                            
                            OverviewCard(title: .constant(totalRevenue.currency), subtitle: "Total Revenue", color: .indigo)
                                .padding([.trailing], 30)
                                .padding(.bottom, 25)
                                .padding(.top, 5)
                                .accessibilityElement(children: .combine)
                                .accessibility(label: Text("Total Revenue"))
                                .accessibility(value: Text(totalRevenue.currency))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Today's Appointments")
                        .padding([.top, .trailing], 20)
                        .padding(.leading, 12)
                        .font(.title3)
                        .bold()
                    
                    if isLoading {
                        CenterSpinner()
                    } else {
                        Table(appointments, sortOrder: $sortOrder) {
                            TableColumn("Patient Name", value: \.patient.firstName)
                            TableColumn("Mobile Number", value: \.patient.phoneNumber.string)
                            TableColumn("Time", value: \.date.dateTimeString)
                            TableColumn("Doctor", value: \.doctor.name)
                            TableColumn("Status") { appointment in
                                AppointmentStatusIndicator(status: appointment.status)
                                    .accessibility(label: Text("Status"))
                                    .accessibility(value: Text(appointment.status.rawValue.capitalized))
                            }
                        }
                        .onChange(of: sortOrder) { newOrder in
                            appointments.sort(using: newOrder)
                        }
                        .frame(height: 600)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Dashboard")
        .onAppear(perform: fetchAppointments)
        .task {
            await self.fetchCounts()
        }
    }
    
    // Fetches the list of today's appointments
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
    
    // Fetches the counts for doctors, lab tests, and revenue
    func fetchCounts() async {
        do {
            async let doctorAsync = Doctor.count()
            async let labTestsAsync = LabTest.count()
            async let revenueAsync = Invoice.fetchRevenue()
            
            let (doctorCount, labTestCount, revenueCount) = try await (doctorAsync, labTestsAsync, revenueAsync)
            
            self.doctorCount = doctorCount
            self.labTestCount = labTestCount
            self.todayRevenue = revenueCount.todayRevenue
            self.totalRevenue = revenueCount.totalRevenue
        } catch {
            print("Error fetching counts: \(error.localizedDescription)")
        }
    }
}

struct OverviewCard: View {
    @Binding var title: String?
    let subtitle: String
    let color: Color

    var body: some View {
        VStack {
            if let title = title {
                Text(title)
                    .font(.largeTitle)
                    .bold()
            } else {
                ProgressView()
                    .padding()
            }
           
            Text(subtitle)
                .font(.subheadline)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(color)
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}

// To display all the Appointment Lists
struct AdminAppointmentsList: View {
    @Binding var appointments: [Appointment]

    var body: some View {
        VStack {
            HStack {
                Text("Patient Name").frame(maxWidth: .infinity, alignment: .leading)
                Text("Mobile Number").frame(maxWidth: .infinity, alignment: .leading)
                Text("Appointment Time").frame(maxWidth: .infinity, alignment: .leading)
                Text("Doctor").frame(maxWidth: .infinity, alignment: .leading)
                Text("Status").frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.caption)
            .textCase(.uppercase)
            .foregroundColor(Color(.systemGray))
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .accessibilityElement(children: .combine)
            
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

// To make One Appointment List
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
        }
        .foregroundColor(Color(.label))
        .accessibilityElement(children: .combine)
        .accessibility(label: Text("Appointment for \(appointment.patient.firstName) with Dr. \(appointment.doctor.firstName)"))
        .accessibility(value: Text("\(appointment.date.timeString)"))
        .accessibilityHint(Text("Status: \(appointment.status.rawValue.capitalized)"))
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
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    AdminDashboardView()
}
