//
//  DoctorDetailsColumn.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct DoctorDetailsColumn: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorViewModel
    
    @StateObject var errorAlertMessage = ErrorAlertMessage()
    @State private var showLogoutAlert = false
    
    var body: some View {
        if let doctor = doctorDetailViewModel.doctor {
            Form {
                Section {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
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
                        Text(doctor.experienceSince.ago)
                    }
                    HStack {
                        Text("Date of Joining")
                        Spacer()
                        Text(doctor.dateOfJoining.dateString)
                    }
                    HStack {
                        Text("Fee")
                        Spacer()
                        Text(doctor.fee.formatted(.currency(code: Constants.currencyCode)))
                    }
                }
                
                Section(header: Text("Account Settings")) {
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                    }
                }
                
                Section {
                    Button(role: .destructive, action: {
                        showLogoutAlert = true
                    }) {
                        Text("Log Out")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.alert(isPresented: $showLogoutAlert) {
                        Alert(
                            title: Text("Confirm Logout"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .destructive(Text("Log Out")) {
                                logOut()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .errorAlert(errorAlertMessage: errorAlertMessage)
        } else {
            CenterSpinner()
        }
    }
    
    private func logOut() {
        Task {
            do {
                try await SupaUser.logout()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    DoctorDetailsColumn().environmentObject(DoctorViewModel())
}
