//
//  SideBarMenu.swift
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
            } else if let errorMessage = adminDoctorViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if adminDoctorViewModel.doctors.isEmpty {
                Image(systemName: "xmark.bin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                    .foregroundColor(Color(.systemGray6))
                
                Text("Tap the + button to add a doctor to this department")
                    .font(.title2)
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(filteredDoctors, id: \.userId) { doctor in
                            
                            NavigationLink(destination: AdminDoctorInfoView(doctor: doctor, doctorsDepartment: department)){
                                
                                DoctorCard(doctor: doctor)
                            }
                        
                        }
                        .padding(.horizontal,4)
                        .foregroundColor(Color(.label))
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(department.name)
        .navigationBarItems(trailing: Button(action: {
            showingForm = true
            print("Plus button tapped")
        }) {
            Image(systemName: "plus")
                .font(.title3)
        })
        .sheet(isPresented: $showingForm) {
            AdminDoctorAddView(department: department).environmentObject(adminDoctorViewModel)
        }
        .task {
            adminDoctorViewModel.fetchDoctors(department: department)
        }
        .searchable(text: $searchText)
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
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(.systemGray))
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.top,4)
            
            Text(doctor.name)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.top,4)

            HStack(spacing: 2) {
                Image(systemName: "envelope.fill")
                Text(doctor.email)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            HStack(spacing: 2) {
                Image(systemName: "phone.fill")
                Text(String(doctor.phoneNumber))
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    AdminDoctorListView(department: Department.sample)
}

