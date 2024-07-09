//
//  DoctorDetailsColumn.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct DoctorDetailsColumn: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorDetailViewModel
    
    @StateObject var errorAlertMessage = ErrorAlertMessage()
    
    var body: some View {
        if let doctor = doctorDetailViewModel.doctor {
            Form {
                Section {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .padding()
                }.frame(maxWidth: .infinity, alignment: .center)
                
                Section(header: Text("Doctor Details")) {
                        Text(doctor.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(doctor.email)
                    }
                    HStack {
                        Text("Gender")
                        Spacer()
                        Text(doctor.gender.id.capitalized)
                    }
                    HStack {
                        Text("Phone")
                        Spacer()
                        Text(String(doctor.phoneNumber))
                    }
                    HStack {
                        Text("Qualification")
                        Spacer()
                        Text(doctor.qualification)
                    }
                    HStack {
                        Text("Year of Experience")
                        Spacer()
                        Text(doctor.experienceSince.yearsOfexperience)
                    }
                    HStack {
                        Text("Date of Joining")
                        Spacer()
                        Text(doctor.dateOfJoining.dateString)
                    }
                }
                
                Section(header: Text("Danger zone")) {
                    Button(role: .destructive, action: logOut) {
                        Text("Log Out").frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }.errorAlert(errorAlertMessage: errorAlertMessage)
        } else {
            ProgressView()
        }
    }
    
    private func logOut() {
        Task {
            do {
                try await SupaUser.logOut()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    DoctorDetailsColumn().environmentObject(DoctorDetailViewModel())
}

