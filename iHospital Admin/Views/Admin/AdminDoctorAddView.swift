//
//  AdminDoctorAddView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//

import SwiftUI

struct AdminDoctorAddView: View {
    let department: Department
    var doctor: Doctor? = nil
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var adminDoctorViewModel: AdminDoctorViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var gender: Gender = .male
    @State private var dateOfBirth = Calendar.current.date(byAdding: .year, value: -24, to: Date())!
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var experienceSince = Date()
    @State private var address = ""
    @State private var qualifications = ""
    @State private var dateOfJoining = Date()
    @State private var fee = ""
    
    @StateObject var errorAlertMessage = ErrorAlertMessage(title: "Unable to add")
    
    @FocusState private var focusedField: Field?
    @State private var isSaving = false
    
    @State private var firstNameError: String?
    @State private var lastNameError: String?
    @State private var emailError: String?
    @State private var phoneNumberError: String?
    @State private var addressError: String?
    @State private var qualificationsError: String?
    @State private var feeError: String?

    enum Field {
        case firstName
        case lastName
        case email
        case phoneNumber
        case address
        case qualifications
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                        .foregroundColor(Color(.systemGray))
                        .frame(maxWidth: .infinity)
                }
                
                Section(header: Text("Personal Information")) {
                    HStack {
                        TextField("First Name", text: $firstName)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            .focused($focusedField, equals: .firstName)
                            .onChange(of: firstName) { _ in validateFirstName() }
                            .overlay(Image.validationIcon(for: firstNameError), alignment: .trailing)
                        Divider()
                        
                        TextField("Last Name", text: $lastName)
                            .textContentType(.familyName)
                            .autocapitalization(.words)
                            .focused($focusedField, equals: .lastName)
                            .onChange(of: lastName) { _ in validateLastName() }
                            .overlay(Image.validationIcon(for: lastNameError), alignment: .trailing)
                    }
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, in: Date.RANGE_MIN_24_YEARS_OLD, displayedComponents: .date)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .phoneNumber)
                        .onChange(of: phoneNumber) { _ in validatePhoneNumber() }
                        .overlay(Image.validationIcon(for: phoneNumberError), alignment: .trailing)
                    
                    if doctor == nil {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .textContentType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .onChange(of: email) { _ in validateEmail() }
                            .overlay(Image.validationIcon(for: emailError), alignment: .trailing)
                    }
                    
                    TextField("Address", text: $address)
                        .focused($focusedField, equals: .address)
                        .onChange(of: address) { _ in validateAddress() }
                        .overlay(Image.validationIcon(for: addressError), alignment: .trailing)
                    
                    TextField("Qualifications", text: $qualifications)
                        .focused($focusedField, equals: .qualifications)
                        .onChange(of: qualifications) { _ in validateQualifications() }
                        .overlay(Image.validationIcon(for: qualificationsError), alignment: .trailing)
                    
                    DatePicker("Date of Joining", selection: $dateOfJoining, in: Date.RANGE_MAX_60_YEARS_AGO, displayedComponents: .date)
                    DatePicker("Practicing Since", selection: $experienceSince, in: Date.RANGE_MAX_60_YEARS_AGO, displayedComponents: .date)
                    TextField("Fee", text: $fee)
                        .keyboardType(.numberPad)
                        .onChange(of: fee) { _ in validateFee() }
                        .overlay(Image.validationIcon(for: feeError), alignment: .trailing)
                }
            }
            .navigationTitle("\(doctor == nil ? "Add New":"Edit") Doctor")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }.disabled(isSaving), trailing: Button("Save") {
                Task {
                    await saveDoctor()
                }
            }.disabled(isSaving))
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .onAppear(perform:onAppear)
        }
    }
    
    private func onAppear() {
        if let doctor = doctor {
            firstName = doctor.firstName
            lastName = doctor.lastName
            gender = doctor.gender
            dateOfBirth = doctor.dateOfBirth
            phoneNumber = doctor.phoneNumber.string
            email = doctor.email
            experienceSince = doctor.experienceSince
            qualifications = doctor.qualification
            dateOfJoining = doctor.dateOfJoining
        }
    }
    
    private func saveDoctor() async {
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
              !email.isEmpty,
              !qualifications.isEmpty,
              !address.isEmpty else {
            errorAlertMessage.message = "Please fill all the fields correctly"
            return
        }
        
        guard let phoneNumber = Int(phoneNumber) else {
            errorAlertMessage.message = "Invalid phone number"
            return
        }
        
        guard let fee = Int(fee) else {
            errorAlertMessage.message = "Invalid fee amount."
            return
        }
        
        isSaving = true
        defer {
            isSaving = false
        }
        
        do {
            if let doctor = doctor {
                doctor.firstName = firstName.trimmed.capitalized
                doctor.lastName = lastName.trimmed.capitalized
                doctor.dateOfBirth = dateOfBirth
                doctor.gender = gender
                doctor.phoneNumber = phoneNumber
                doctor.qualification = qualifications.trimmed
                doctor.experienceSince = experienceSince
                doctor.dateOfJoining = dateOfJoining
                try await doctor.save()
            } else {
                let doctor = Doctor(userId: UUID(), firstName: firstName.trimmed.capitalized, lastName: lastName.trimmed.capitalized, dateOfBirth: dateOfBirth, gender: gender, phoneNumber: phoneNumber, email: email.trimmed, qualification: email.trimmed, experienceSince: experienceSince, dateOfJoining: dateOfJoining, departmentId: department.id, fee: fee, doctorSettings: DoctorSettings.sample)
                try await adminDoctorViewModel.new(doctor: doctor)
            }
            presentationMode.wrappedValue.dismiss()
        } catch {
            errorAlertMessage.message = error.localizedDescription
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
        if email.isEmpty {
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
    
    private func validateFee() {
        if let fee = Int(fee) {
            if fee >= 3000 {
                feeError = "Fee must be less than 3,000."
            } else if fee <= 299 {
                feeError = "Fee must be equal or greater than 299."
            } else {
                feeError = nil
            }
        } else {
            feeError = "Fee must be a number."
        }
    }
}

#Preview {
    AdminDoctorAddView(department: Department.sample)
}
