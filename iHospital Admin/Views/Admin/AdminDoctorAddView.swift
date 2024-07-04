//
//  AdminDoctorAddView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//

import SwiftUI

struct AdminDoctorAddView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var firstName = ""
    @State private var gender = ""
    @State private var dob = Date()
    @State private var mobile = ""
    @State private var department = ""
    @State private var experience = ""
    @State private var address = ""
    @State private var qualifications = ""
    
    var body: some View {
        NavigationView {
            
            Form{
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
                    TextField("Gender", text: $gender)
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                    TextField("Mobile", text: $mobile)
                    TextField("Address", text: $address)
                    DatePicker("Date of Joining", selection: $dob, displayedComponents: .date)
                    TextField("Department", text: $department)
                    TextField("Qualifications", text: $qualifications)
                    TextField("Experience", text: $experience)
                }
            }
            .navigationTitle("Add Profile")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                // Save action
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
        
}
#Preview {
    AdminDoctorAddView()
}
