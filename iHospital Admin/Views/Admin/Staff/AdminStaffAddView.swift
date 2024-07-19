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

    @State private var firstNameError: String?
    @State private var lastNameError: String?
    @State private var emailError: String?
    @State private var phoneNumberError: String?
    @State private var addressError: String?
    @State private var qualificationsError: String?

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
                        .accessibilityHidden(true)
                }
                Section(header: Text("Personal Information").accessibilityAddTraits(.isHeader)) {
                    TextField("First Name", text: $firstName)
                        .accessibilityLabel("First Name")
                        .accessibilityHint("Enter the first name")
                        .onChange(of: firstName) { _ in validateFirstName() }
                        .overlay(Image.validationIcon(for: firstNameError), alignment: .trailing)
                    TextField("Last Name", text: $lastName)
                        .accessibilityLabel("Last Name")
                        .accessibilityHint("Enter the last name")
                        .onChange(of: lastName) { _ in validateLastName() }
                        .overlay(Image.validationIcon(for: lastNameError), alignment: .trailing)
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                    .accessibilityLabel("Gender")
                    .accessibilityHint("Select the gender")
                    DatePicker("Date of Birth", selection: $dob, in: Date.RANGE_MIN_18_YEARS_OLD, displayedComponents: .date)
                        .accessibilityLabel("Date of Birth")
                        .accessibilityHint("Select the date of birth")
                    TextField("Phone Number", text: $phoneNumber)
                        .accessibilityLabel("Phone Number")
                        .accessibilityHint("Enter the phone number")
                        .onChange(of: phoneNumber) { _ in validatePhoneNumber() }
                        .overlay(Image.validationIcon(for: phoneNumberError), alignment: .trailing)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .accessibilityLabel("Email")
                        .accessibilityHint("Enter the email address")
                        .onChange(of: email) { _ in validateEmail() }
                        .disabled(staffType == .labTechnician && staffId != nil)
                        .overlay(Image.validationIcon(for: emailError), alignment: .trailing)
                    TextField("Address", text: $address)
                        .accessibilityLabel("Address")
                        .accessibilityHint("Enter the address")
                        .onChange(of: address) { _ in validateAddress() }
                        .overlay(Image.validationIcon(for: addressError), alignment: .trailing)
                    DatePicker("Date of Joining", selection: $dateOfJoining, in: ...Date(), displayedComponents: .date)
                        .accessibilityLabel("Date of Joining")
                        .accessibilityHint("Select the date of joining")
                    TextField("Qualifications", text: $qualifications)
                        .accessibilityLabel("Qualifications")
                        .accessibilityHint("Enter the qualifications")
                        .onChange(of: qualifications) { _ in validateQualifications() }
                        .overlay(Image.validationIcon(for: qualificationsError), alignment: .trailing)
                    DatePicker("Experience Since", selection: $experienceSince, in: ...Date(), displayedComponents: .date)
                        .accessibilityLabel("Experience Since")
                        .accessibilityHint("Select the experience start date")
                }
            }
            .navigationTitle(staffId == nil ? "Add Profile" : "Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(isSaving)
            .accessibilityLabel("Cancel")
            .accessibilityHint("Cancel adding or editing the staff profile"),
            trailing: Button("Save") {
                saveProfile()
            }
            .disabled(isSaving)
            .accessibilityLabel("Save")
            .accessibilityHint("Save the staff profile"))
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
        validateFirstName()
        validateLastName()
        validateEmail()
        validatePhoneNumber()
        validateAddress()
        validateQualifications()
        
        guard firstNameError == nil,
              lastNameError == nil,
              emailError == nil,
              phoneNumberError == nil,
              addressError == nil,
              qualificationsError == nil,
              !firstName.isEmpty,
              !lastName.isEmpty,
              (staffType == .labTechnician || !email.isEmpty),
              !qualifications.isEmpty,
              !address.isEmpty else {
            errorAlertMessage.message = "Please fill all the fields correctly"
            return
        }
        
        guard let phoneNumber = Int(phoneNumber) else {
            errorAlertMessage.message = "Invalid phone number"
            return
        }
        
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
                    staff.phoneNumber = phoneNumber
                    staff.address = address
                    staff.qualification = qualifications
                    staff.dateOfJoining = dateOfJoining
                    staff.experienceSince = experienceSince
                    
                    try await staffViewModel.save(staff: staff)
                } else {
                    try await staffViewModel.newStaff(
                        firstName: firstName.trimmed.capitalized,
                        lastName: lastName.trimmed.capitalized,
                        dateOfBirth: dob,
                        gender: gender,
                        email: email.trimmed,
                        phoneNumber: phoneNumber,
                        address: address.trimmed,
                        dateOfJoining: dateOfJoining,
                        qualification: qualifications.trimmed,
                        experienceSince: experienceSince,
                        type: staffType
                    )
                }
                presentationMode.wrappedValue.dismiss()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    private func validateFirstName() {
        if firstName.isEmpty {
            firstNameError = "First name is required."
        } else if !firstName.isAlphabets {
            firstNameError = "First name must contain only alphabets."
        } else {
            firstNameError = nil
        }
    }

    private func validateLastName() {
        if lastName.isEmpty {
            lastNameError = "Last name is required."
        } else if !lastName.isAlphabetsAndSpace {
            lastNameError = "Last name must contain only alphabets and spaces."
        } else {
            lastNameError = nil
        }
    }

    private func validateEmail() {
        if email.isEmpty && staffType != .labTechnician {
            emailError = "Email is required."
        } else if !email.isEmail {
            emailError = "Invalid email."
        } else {
            emailError = nil
        }
    }

    private func validatePhoneNumber() {
        if phoneNumber.isEmpty {
            phoneNumberError = "Phone number is required."
        } else if !phoneNumber.isPhoneNumber {
            phoneNumberError = "Invalid phone number, must be 10 digits."
        } else {
            phoneNumberError = nil
        }
    }

    private func validateAddress() {
        if address.isEmpty {
            addressError = "Address is required."
        } else {
            addressError = nil
        }
    }

    private func validateQualifications() {
        if qualifications.isEmpty {
            qualificationsError = "Qualifications are required."
        } else {
            qualificationsError = nil
        }
    }
}

#Preview {
    AdminStaffAddView(staffType: .nursing)
        .environmentObject(AdminStaffViewModel())
}
