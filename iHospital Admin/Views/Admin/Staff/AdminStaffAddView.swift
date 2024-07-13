//
//  AdminStaffAddView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 05/07/24.
//

import SwiftUI

struct AdminStaffAddView: View {
    var staffType: StaffDepartment
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var staffViewModel: AdminStaffViewModel

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var gender = Gender.male
    @State private var dob = Date()
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var address = ""
    @State private var qualifications = ""
    @State private var dateOfJoining = Date()
    @State private var experienceSince = Date()
    @State private var isSaving = false
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to save")

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                    TextField("Phone Number", text: $phoneNumber)
                    TextField("Email", text: $email)
                    TextField("Address", text: $address)
                    DatePicker("Date of Joining", selection: $dateOfJoining, displayedComponents: .date)
                    TextField("Qualifications", text: $qualifications)
                    DatePicker("Experience Since", selection: $experienceSince, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Profile")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(isSaving),
            trailing: Button("Save") {
                saveProfile()
            }
            .disabled(isSaving))
        }
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .interactiveDismissDisabled()
    }

    private func saveProfile() {
        Task {
            isSaving = true
            defer {
                isSaving = false
            }
            
            do {
                try await staffViewModel.newStaff(
                    firstName: firstName,
                    lastName: lastName,
                    dateOfBirth: dob,
                    gender: gender,
                    email: email,
                    phoneNumber: Int(phoneNumber) ?? 0,
                    address: address,
                    dateOfJoining: dateOfJoining,
                    qualification: qualifications,
                    experienceSince: experienceSince,
                    type: staffType
                )
                presentationMode.wrappedValue.dismiss()
            } catch {
                errorAlertMessage.message = error.localizedDescription
                print("Failed to save staff: \(error)")
            }
        }
    }
}

#Preview {
    AdminStaffAddView(staffType: .nursing)
}
