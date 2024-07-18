//
//  LabTechnicianProfile.swift
//  iHospital Admin
//
//  Created by Aditya on 18/07/24.
//

import SwiftUI

struct LabTechnicianProfile: View {
    @EnvironmentObject var labTechnicianViewModel: LabTechViewModel
    @StateObject var errorAlertMessage = ErrorAlertMessage()
    @State private var showLogoutAlert = false

    var body: some View {
        HStack{
            if let labTech = labTechnicianViewModel.labTech {
                Form{
                    if let userId = labTech.userId {
                        Section{
                            ProfileImageChangeable(userId: userId.uuidString)
                        }
                    }
                    
                    Section(header: Text("Lab Technician Details")){
                        HStack{
                            Text("Name")
                            Spacer()
                            Text(labTech.name)
                        }
                        HStack{
                            Text("Gender")
                            Spacer()
                            Text(labTech.gender.id.capitalized)
                        }
                        HStack{
                            Text("Age")
                            Spacer()
                            Text(labTech.dateOfBirth.ago)
                        }
                        HStack{
                            Text("Phone Number")
                            Spacer()
                            Text(labTech.phoneNumber.string)
                        }
                        HStack{
                            Text("Email")
                            Spacer()
                            Text(labTech.email)
                        }
                        HStack{
                            Text("Date Of Joining")
                            Spacer()
                            Text(labTech.dateOfJoining.ago)
                        }
                        HStack{
                            Text("Qualification")
                            Spacer()
                            Text(labTech.qualification)
                        }
                        HStack{
                            Text("Experience Since")
                            Spacer()
                            Text(labTech.experienceSince.ago)
                        }
                    }
                }
                Form{
                    
                    Section(header: Text("Account Settings")) {
                        NavigationLink(destination: ChangePasswordView(shouldDismiss: true)) {
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
            }
                
        }
        .navigationTitle("Profile")
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
    LabTechnicianProfile()
}
