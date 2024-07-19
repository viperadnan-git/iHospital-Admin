//
//  DoctorDashboardView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//


import SwiftUI

struct DoctorDashboardView: View {
    @StateObject private var doctorViewModel = DoctorViewModel()
    @StateObject private var navigation = NavigationManager()
    
    @State private var searchText = ""

    var body: some View {
        if doctorViewModel.isLoading {
            CenterSpinner()
        } else {
            NavigationStack(path: $navigation.path) {
                GeometryReader { geometry in
                    let screenWidth = geometry.size.width
                    let boxWidth = screenWidth * 0.4
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 10) {
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .overlay(
                                        VStack(alignment: .leading) {
                                            HStack(alignment: .bottom) {
                                                Text(doctorViewModel.remainingAppointments.count.string + "/")
                                                    .font(.system(size: 80, weight: .bold))
                                                Text(doctorViewModel.appointments.count.string)
                                            }
                                            .foregroundColor(.white)
                                            .font(.system(size: 60, weight: .bold))
                                            .accessibilityElement(children: .combine)
                                            .accessibilityLabel("Remaining and total appointments")
                                            .accessibilityValue("\(doctorViewModel.remainingAppointments.count) remaining out of \(doctorViewModel.appointments.count) appointments")
                                            
                                            Spacer()
                                            
                                            Text("Remaining / Total")
                                                .font(.caption)
                                                .textCase(.uppercase)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            Text("Appointments")
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding()
                                    )
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.purple)
                                    .overlay(
                                        VStack(alignment: .leading) {
                                            Spacer()
                                            Text(doctorViewModel.revenue.formatted(.currency(code: Constants.currencyCode)))
                                                .foregroundColor(.white)
                                                .font(.system(size: 30, weight: .bold))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .accessibilityLabel("Today's revenue")
                                                .accessibilityValue(doctorViewModel.revenue.formatted(.currency(code: Constants.currencyCode)))
                                            Text("Today's")
                                                .font(.caption)
                                                .textCase(.uppercase)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            Text("Revenue")
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding()
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                if let currentAppointment = doctorViewModel.nextAppointment {
                                    HStack(alignment: .top) {
                                        Text("Current Appointment")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .accessibilityLabel("Current appointment")
                                        Spacer()
                                        HStack(spacing: 5) {
                                            Image(systemName: "clock.fill")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                                .foregroundColor(.white)
                                            Text(currentAppointment.date.timeString)
                                                .foregroundColor(.white)
                                                .accessibilityLabel("Time")
                                                .accessibilityValue(currentAppointment.date.timeString)
                                        }
                                    }
                                    Spacer()
                                    
                                    HStack {
                                        Image(systemName: "phone.fill")
                                            .resizable()
                                            .frame(width: 22, height: 22)
                                            .foregroundColor(.white)
                                        Text(currentAppointment.patient.phoneNumber.string)
                                            .foregroundColor(.white)
                                            .accessibilityLabel("Phone number")
                                            .accessibilityValue(currentAppointment.patient.phoneNumber.string)
                                    }
                                    HStack(alignment: .bottom) {
                                        Text(currentAppointment.patient.name)
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .bold()
                                            .accessibilityLabel("Patient name")
                                            .accessibilityValue(currentAppointment.patient.name)
                                        Spacer()
                                        Button {
                                            navigation.path.append(currentAppointment)
                                        } label: {
                                            Image(systemName: "arrow.right.circle.fill")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.white)
                                                .accessibilityLabel("Go to appointment details")
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                } else if let nextAppointment = doctorViewModel.nextAppointment {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(alignment: .top) {
                                            Text("Next Appointment")
                                                .font(.title)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .accessibilityLabel("Next appointment")
                                            Spacer()
                                            HStack(spacing: 5) {
                                                Image(systemName: "clock.fill")
                                                    .resizable()
                                                    .frame(width: 22, height: 22)
                                                    .foregroundColor(.white)
                                                Text(nextAppointment.date.timeString)
                                                    .foregroundColor(.white)
                                                    .accessibilityLabel("Time")
                                                    .accessibilityValue(nextAppointment.date.timeString)
                                            }
                                        }
                                        Spacer()
                                        
                                        HStack {
                                            Image(systemName: "phone.fill")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                                .foregroundColor(.white)
                                            Text(nextAppointment.patient.phoneNumber.string)
                                                .foregroundColor(.white)
                                                .accessibilityLabel("Phone number")
                                                .accessibilityValue(nextAppointment.patient.phoneNumber.string)
                                        }
                                        HStack(alignment: .bottom) {
                                            Text(nextAppointment.patient.name)
                                                .foregroundColor(.white)
                                                .font(.title)
                                                .bold()
                                                .accessibilityLabel("Patient name")
                                                .accessibilityValue(nextAppointment.patient.name)
                                            Spacer()
                                        }
                                    }
                                    
                                } else {
                                    HStack {
                                        Text("No Appointments\nfor today")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .accessibilityLabel("No appointments for today")
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }.padding()
                                .frame(width: boxWidth, height: 180)
                                .background(Color(.systemGreen))
                                .cornerRadius(10)
                            
                        }
                        .frame(height: 180)
                        .padding()
                        
                        HStack {
                            Text("Appointments")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Button {
                                navigation.path.append("allAppointments")
                            } label: {
                                Text("View All")
                            }
                            .accessibilityLabel("View all appointments")
                        }
                        .padding()
                        
                        DoctorAppointmentsTable()
                        Spacer()
                    }
                    .navigationTitle("Hello \(doctorViewModel.doctor?.firstName ?? "Doctor")")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationDestination(for: String.self) { value in
                        switch value {
                        case "settings":
                            DoctorSettingView()
                        case "allAppointments":
                            DoctorAppointmentsView()
                        default:
                            EmptyView()
                        }
                    }
                    .navigationDestination(for: Appointment.self) { appointment in
                        DoctorPatientInfoView(appointment: appointment)
                    }
                    .navigationBarItems(
                        trailing: Button {
                            navigation.path.append("settings")
                        } label: {
                            ProfileImage(userId: doctorViewModel.doctor?.userId.uuidString ?? "")
                                .frame(width: 40, height: 40)
                                .accessibilityLabel("Profile settings")
                        }
                    )
                }
            }.environmentObject(navigation)
            .environmentObject(doctorViewModel)
        }
    }
}

#Preview {
    DoctorDashboardView()
}
