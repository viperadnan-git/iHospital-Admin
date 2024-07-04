//
//  DoctorView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//
import SwiftUI

struct AdminDoctorListView: View {
    let department: Department
    @StateObject private var viewModel = AdminDoctorViewModel()
    @State private var showingForm = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.doctors, id: \.userId) { doctor in
                            DoctorView(doctor: doctor)
                        }
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
            AdminDoctorAddView(department: department)
        }
        .task {
            viewModel.fetchDoctors(department: department)
        }
    }
}

struct DoctorView: View {
    let doctor: Doctor

    var body: some View {
        VStack {
            Text(doctor.name)
                .font(.headline)
            Text(doctor.email)
                .font(.subheadline)
            Text("\(doctor.phoneNumber.formatted(.number))")
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

#Preview {
    AdminDoctorListView(department: Department(id: UUID(), name: "Cardiology", phoneNumber: nil))
}
