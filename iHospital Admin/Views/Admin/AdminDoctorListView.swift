//
//  AdminDoctorListView.swift
//  iHospital Admin
//
//  Created by Aditya on 05/07/24.
//

import SwiftUI

struct AdminDoctorListView: View {
    @State private var searchText = ""

    let department: Department
    
    @StateObject private var adminDoctorViewModel = AdminDoctorViewModel()
    @State private var showingForm = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            if adminDoctorViewModel.isLoading {
                CenterSpinner()
                    .accessibilityLabel("Loading")
                    .accessibilityHint("Fetching the list of doctors")
            } else if let errorMessage = adminDoctorViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .accessibilityLabel("Error")
                    .accessibilityHint(errorMessage)
            } else if adminDoctorViewModel.doctors.isEmpty {
                Image(systemName: "xmark.bin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                    .foregroundColor(Color(.systemGray6))
                    .accessibilityHidden(true)
                
                Text("Tap the + button to add a doctor to this department")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .accessibilityLabel("No doctors found")
                    .accessibilityHint("Tap the add button to add a doctor to this department")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(filteredDoctors, id: \.userId) { doctor in
                            NavigationLink(destination: AdminDoctorInfoView(doctor: doctor, doctorsDepartment: department)) {
                                DoctorCard(doctor: doctor)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 4)
                            .foregroundColor(Color(.label))
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(department.name)
        .navigationBarItems(trailing: Button(action: {
            showingForm = true
        }) {
            Image(systemName: "plus")
                .font(.title3)
                .accessibilityLabel("Add Doctor")
                .accessibilityHint("Tap to add a new doctor to the department")
        })
        .sheet(isPresented: $showingForm) {
            AdminDoctorAddView(department: department).environmentObject(adminDoctorViewModel)
        }
        .task {
            adminDoctorViewModel.fetchDoctors(department: department)
        }
        .refreshable {
            adminDoctorViewModel.fetchDoctors(department: department, showLoader: false, force: true)
        }
        .searchable(text: $searchText)
        .accessibilityLabel("Search Doctors")
        .accessibilityHint("Search for doctors by name, email, or phone number")
    }
    
    private var filteredDoctors: [Doctor] {
        if searchText.isEmpty {
            return adminDoctorViewModel.doctors
        } else {
            return adminDoctorViewModel.doctors.filter { doctor in
                doctor.name.lowercased().contains(searchText.lowercased())
                || doctor.email.lowercased().contains(searchText.lowercased())
                || doctor.phoneNumber.string.contains(searchText.lowercased())
            }
        }
    }
}

struct DoctorCard: View {
    let doctor: Doctor

    var body: some View {
        VStack {
            ProfileImage(userId: doctor.userId.uuidString)
                .foregroundColor(Color(.systemGray))
                .frame(width: 80, height: 80)
                .padding(.top, 4)
                .accessibilityHidden(true)
            
            Text(doctor.name)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.top, 4)
                .accessibilityLabel("Doctor Name")
                .accessibilityValue(doctor.name)

            HStack(spacing: 2) {
                Image(systemName: "envelope.fill")
                    .accessibilityHidden(true)
                Text(doctor.email)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .accessibilityLabel("Email")
                    .accessibilityValue(doctor.email)
            }
            
            HStack(spacing: 2) {
                Image(systemName: "phone.fill")
                    .accessibilityHidden(true)
                Text(String(doctor.phoneNumber))
                    .font(.subheadline)
                    .accessibilityLabel("Phone Number")
                    .accessibilityValue(String(doctor.phoneNumber))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Doctor Card")
    }
}

#Preview {
    AdminDoctorListView(department: Department.sample)
}
