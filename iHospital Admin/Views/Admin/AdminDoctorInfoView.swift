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

    
    var body: some View {
        Form {
            VStack{
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                    .foregroundColor(Color(.systemGray))
                    .frame(maxWidth: .infinity)
                
                Text(doctor.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
            
            Section(header: Text("Doctor Information")) {
                
                
                HStack {
                    Text("Name")
                    Spacer()
                    Text(doctor.name)
                }
                HStack {
                    Text("Date of Birth")
                    Spacer()
                    Text(doctor.dateOfBirth.dateString)
                }
                HStack {
                    Text("Gender")
                    Spacer()
                    Text(doctor.gender.id.capitalized)
                }
                HStack {
                    Text("Phone Number")
                    Spacer()
                    Text(doctor.phoneNumber.string)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(doctor.email)
                }
                HStack {
                    Text("Qualification")
                    Spacer()
                    Text(doctor.qualification)
                }
                HStack {
                    Text("Experience Since")
                    Spacer()
                    Text(doctor.experienceSince.dateString)
                }
                HStack {
                    Text("Date of Joining")
                    Spacer()
                    Text(doctor.dateOfJoining.dateString)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AdminDoctorAddView(department: doctorsDepartment,doctor: doctor)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditSheet.toggle()
                }
            }
        }

    }
}

//#Preview {
//    AdminDoctorInfoView(d)
//}

