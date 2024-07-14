//
//  AdminStaffAddView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 05/07/24.
//

import SwiftUI

struct AdminStaffAddView: View {
    var staffType: StaffDepartment
    var staffId: Int?
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var staffViewModel: AdminStaffViewModel

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gender: Gender = .male
    @State private var dob: Date = Date()
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var qualifications: String = ""
    @State private var dateOfJoining: Date = Date()
    @State private var experienceSince: Date = Date()
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
            .navigationTitle(staffId == nil ? "Add Profile" : "Edit Profile")
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
        .onAppear {
            if let staffId = staffId {
                if let staff = staffViewModel.staffs.first(where: { $0.id == staffId }) {
                    firstName = staff.firstName
                    lastName = staff.lastName
                    gender = staff.gender
                    dob = staff.dateOfBirth
                    phoneNumber = String(staff.phoneNumber)
                    email = staff.email
                    address = staff.address
                    qualifications = staff.qualification
                    dateOfJoining = staff.dateOfJoining
                    experienceSince = staff.experienceSince
                }
            }
        }
    }

    private func saveProfile() {
        Task {
            isSaving = true
            defer {
                isSaving = false
            }
            
            do {
                if let staffId = staffId {
                    guard let staff = staffViewModel.staffs.first(where: { $0.id == staffId }) else {
                        errorAlertMessage.message = "Staff not found"
                        return
                    }
                    
                    staff.firstName = firstName
                    staff.lastName = lastName
                    staff.gender = gender
                    staff.dateOfBirth = dob
                    staff.phoneNumber = Int(phoneNumber) ?? 0
                    staff.email = email
                    staff.address = address
                    staff.qualification = qualifications
                    staff.dateOfJoining = dateOfJoining
                    staff.experienceSince = experienceSince

                    try await staffViewModel.save(staff: staff)
                } else {
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
                }
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
        .environmentObject(AdminStaffViewModel())
}
