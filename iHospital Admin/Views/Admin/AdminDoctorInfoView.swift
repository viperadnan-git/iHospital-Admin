//
//  AdminDoctorInfoView.swift
//  iHospital Admin
//
//  Created by Aditya on 11/07/24.
//

import SwiftUI

struct AdminDoctorInfoView: View {
    var doctor: Doctor
    var doctorsDepartment: Department
    
    @State private var showEditSheet = false
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to delete doctor")
    
    var body: some View {
        Form {
            VStack {
                ProfileImage(userId: doctor.userId.uuidString)
                    .frame(width: 200, height: 200)
                    .padding()
                    .foregroundColor(Color(.systemGray))
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Profile picture")
                    .accessibilityHidden(true)
                
                Text(doctor.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .accessibilityLabel("Doctor name")
                    .accessibilityValue(doctor.name)
            }
            
            Section(header: Text("Doctor Information")) {
                InfoRow(label: "Name", value: doctor.name)
                InfoRow(label: "Date of Birth", value: doctor.dateOfBirth.dateString)
                InfoRow(label: "Gender", value: doctor.gender.id.capitalized)
                InfoRow(label: "Phone Number", value: doctor.phoneNumber.string)
                InfoRow(label: "Email", value: doctor.email)
                InfoRow(label: "Qualification", value: doctor.qualification)
                InfoRow(label: "Experience Since", value: doctor.experienceSince.dateString)
                InfoRow(label: "Date of Joining", value: doctor.dateOfJoining.dateString)
            }
            
            Button(role: .destructive) {
                showAlert.toggle()
            } label: {
                Text("Delete")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Doctor's Info"),
                    message: Text("Are you sure you want to delete this doctor's information?"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        deleteDoctor()
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AdminDoctorAddView(department: doctorsDepartment, doctor: doctor)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditSheet.toggle()
                }
                .accessibilityLabel("Edit doctor information")
            }
        }
        .navigationTitle("Doctor Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteDoctor() {
        print("Deleted Successfully")
        
        Task {
            do {
                try await doctor.delete()
                presentationMode.wrappedValue.dismiss()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .accessibilityLabel(label)
                .accessibilityValue(value)
        }
    }
}

#Preview {
    AdminDoctorInfoView(doctor: .sample, doctorsDepartment: .sample)
}
