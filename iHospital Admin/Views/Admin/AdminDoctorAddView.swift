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

    @State private var firstName = ""
    @State private var gender: Gender = .male
    @State private var dateOfBirth = Calendar.current.date(byAdding: .year, value: -24, to: Date())!
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var experience = ""
    @State private var address = ""
    @State private var qualifications = ""
    @State private var dateOfJoining = Date()

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
                    TextField("Full Name", text: $firstName)

                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    TextField("Phone Number", text: $phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                    TextField("Address", text: $address)
                    DatePicker("Date of Joining", selection: $dateOfJoining, displayedComponents: .date)
                    TextField("Qualifications", text: $qualifications)
                    TextField("Experience", text: $experience)
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
        }
    }

    func saveDoctor() async {
        guard !firstName.isEmpty, !email.isEmpty, !qualifications.isEmpty else { return }
        
        guard let phoneNumber = Int(phoneNumber) else { return }
        
        do {
            try await Doctor.addDoctor(
                name: firstName,
                dateOfBirth: dateOfBirth,
                gender: gender,
                phoneNumber: phoneNumber,
                email: email,
                qualification: qualifications,
                experienceSince: dateOfBirth,
                dateOfJoining: dateOfJoining,
                departmentId: department.id
            )
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to add doctor: \(error)")
        }
    }
}

#Preview {
    AdminDoctorAddView(department: Department(id: UUID(), name: "Cardiology", phoneNumber: nil))
}
