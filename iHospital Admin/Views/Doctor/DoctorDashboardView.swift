//
//  DoctorDashboardView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//


import SwiftUI

struct DoctorDashboardView: View {
    @StateObject private var doctorViewModel = DoctorViewModel()
    @State private var searchText = ""
    @State private var appointments: [Appointment] = []
    @StateObject private var navigation = NavigationManager()
    
    var body: some View {
        if doctorViewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)
        } else {
            NavigationStack(path: $navigation.path) {
                GeometryReader { geometry in
                    let screenWidth = geometry.size.width
                    let boxWidth = screenWidth * 0.4
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 10) {
                            HStack(spacing: 10) { // Adjusted spacing
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .overlay(
                                        VStack(alignment: .leading) {
                                            HStack(alignment: .bottom) {
                                                Text(doctorViewModel.appointments.count.string + "/")
                                                    .font(.system(size: 80, weight: .bold))
                                                Text(doctorViewModel.appointments.count.string)
                                            }.foregroundColor(.white)
                                                .font(.system(size: 60, weight: .bold))
                                            
                                            Spacer()
                                      
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
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(9800.formatted(.currency(code: Constants.currencyCode)))
                                                .foregroundColor(.white)
                                                .font(.system(size: 60, weight: .bold))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 1)
                                            Text("Revenue")
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.top, 40)
                                            Spacer()
                                        }
                                            .padding()
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                if let currentAppointment = doctorViewModel.appointments.first {
                                    HStack(alignment: .top) {
                                        Text("Current Appointment")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        Spacer()
                                        HStack(spacing: 5) {
                                            Image(systemName: "clock.fill")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                                .foregroundColor(.white)
                                            Text(currentAppointment.date.timeString)
                                                .foregroundColor(.white)
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
                                    }
                                    HStack(alignment: .bottom) {
                                        Text(currentAppointment.patient.name)
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .bold()
                                        Spacer()
                                        Button(action: {
                                            navigation.path.append(currentAppointment.patient)
                                        }) {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.white)
                                                .overlay(
                                                    Text("View")
                                                        .foregroundColor(.accentColor)
                                                        .padding(.horizontal, 2)
                                                        .padding(.vertical, 2)
                                                ).frame(maxWidth: 20)
                                        }
                                        .padding(.bottom, 10)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                } else if let nextAppointment = doctorViewModel.nextAppointment {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(alignment: .top) {
                                            Text("Next Appointment")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            Spacer()
                                            HStack(spacing: 5) {
                                                Image(systemName: "clock.fill")
                                                    .resizable()
                                                    .frame(width: 22, height: 22)
                                                    .foregroundColor(.white)
                                                Text(nextAppointment.date.timeString)
                                                    .foregroundColor(.white)
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
                                        }
                                        HStack(alignment: .bottom) {
                                            Text(nextAppointment.patient.name)
                                                .foregroundColor(.white)
                                                .font(.title)
                                                .bold()
                                            Spacer()
                                        }
                                    }
                                    
                                }
                                else {
                                    HStack {
                                        Text("No Appointments\nfor today")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }.padding()
                                .frame(width: boxWidth, height: 180)
                                .background(Color(hex: "ef9c66"))
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
                        }
                        .padding()
                        
                        DoctorAppointmentsTable()
                            .onAppear {
                                Task {
                                    do {
                                        appointments = try await Appointment.fetchAppointments()
                                    } catch {
                                        print("Error fetching appointments: \(error.localizedDescription)")
                                    }
                                }
                            }
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
                    .navigationDestination(for: Patient.self) { patient in
                        DoctorPatientInfoView(patient: patient)
                    }
                    .navigationBarItems(
                        trailing: Button {
                            navigation.path.append("settings")
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
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
