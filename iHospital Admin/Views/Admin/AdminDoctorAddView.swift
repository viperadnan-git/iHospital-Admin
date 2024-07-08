//
//  AdminDoctorAddView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//

import SwiftUI

struct AdminDoctorAddView: View {
    let department: Department
    
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
    
    @StateObject var errorAlertMessage = ErrorAlertMessage(title: "Unable to add")
    
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
                    HStack {
                        TextField("First Name", text: $firstName)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                        
                        TextField("Last Name", text: $lastName)
                            .textContentType(.familyName)
                            .autocapitalization(.words)
                    }
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, in: Date.RANGE_MIN_24_YEARS_OLD, displayedComponents: .date)
                    TextField("Phone Number", text: $phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                    TextField("Address", text: $address)
                    TextField("Qualifications", text: $qualifications)
                    DatePicker("Date of Joining", selection: $dateOfJoining, in: Date.RANGE_MAX_60_YEARS_AGO,  displayedComponents: .date)
                    DatePicker("Practicing Since", selection: $experienceSince, in: Date.RANGE_MAX_60_YEARS_AGO,  displayedComponents: .date)
                }
            }
            .navigationTitle("Add Doctor")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                Task {
                    await saveDoctor()
                }
            })
            .errorAlert(errorAlertMessage: errorAlertMessage)
        }
    }
    
    func saveDoctor() async {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !qualifications.isEmpty, !address.isEmpty else {
            errorAlertMessage.message = "Please fill all the fields"
            return
        }
        
        guard firstName.isAlphabets else {
            errorAlertMessage.message = "Invalid first name, must contain only alphabets"
            return
        }
        
        guard lastName.isAlphabetsAndSpace else {
            errorAlertMessage.message = "Invalid last name, must contain only alphabets and spaces"
            return
        }
        
        guard email.isEmail else {
            errorAlertMessage.message = "Invalid email"
            return
        }
        
        guard phoneNumber.count == 10 else {
            errorAlertMessage.message = "Invalid phone number, must be 10 digits"
            return
        }
        
        guard let phoneNumber = Int(phoneNumber) else { return
            errorAlertMessage.message = "Invalid phone number"
        }
        
        do {
            try await adminDoctorViewModel.addDoctor(
                firstName: firstName.trimmed.capitalized,
                lastName: lastName.trimmed.capitalized,
                dateOfBirth: dateOfBirth,
                gender: gender,
                phoneNumber: phoneNumber,
                email: email.trimmed,
                qualification: qualifications.trimmed,
                experienceSince: experienceSince,
                dateOfJoining: dateOfJoining,
                departmentId: department.id
            )
            presentationMode.wrappedValue.dismiss()
        } catch {
            errorAlertMessage.message = error.localizedDescription
        }
    }
}

#Preview {
    AdminDoctorAddView(department: Department(id: UUID(), name: "Cardiology", phoneNumber: nil))
}
