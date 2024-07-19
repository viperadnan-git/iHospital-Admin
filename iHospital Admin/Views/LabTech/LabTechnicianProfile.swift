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
        HStack {
            if let labTech = labTechnicianViewModel.labTech {
                Form {
                    if let userId = labTech.userId {
                        Section {
                            ProfileImageChangeable(userId: userId.uuidString)
                                .accessibilityLabel("Profile Image")
                                .accessibilityHint("Tap to change profile image")
                        }
                    }
                    
                    Section(header: Text("Lab Technician Details")
                        .accessibilityLabel("Lab Technician Details Section")) {
                        HStack {
                            Text("Name")
                                .accessibilityLabel("Name")
                            Spacer()
                            Text(labTech.name)
                                .accessibilityLabel("Name: \(labTech.name)")
                        }
                        HStack {
                            Text("Gender")
                                .accessibilityLabel("Gender")
                            Spacer()
                            Text(labTech.gender.id.capitalized)
                                .accessibilityLabel("Gender: \(labTech.gender.id.capitalized)")
                        }
                        HStack {
                            Text("Age")
                                .accessibilityLabel("Age")
                            Spacer()
                            Text(labTech.dateOfBirth.ago)
                                .accessibilityLabel("Age: \(labTech.dateOfBirth.ago)")
                        }
                        HStack {
                            Text("Phone Number")
                                .accessibilityLabel("Phone Number")
                            Spacer()
                            Text(labTech.phoneNumber.string)
                                .accessibilityLabel("Phone Number: \(labTech.phoneNumber.string)")
                        }
                        HStack {
                            Text("Email")
                                .accessibilityLabel("Email")
                            Spacer()
                            Text(labTech.email)
                                .accessibilityLabel("Email: \(labTech.email)")
                        }
                        HStack {
                            Text("Date Of Joining")
                                .accessibilityLabel("Date Of Joining")
                            Spacer()
                            Text(labTech.dateOfJoining.ago)
                                .accessibilityLabel("Date Of Joining: \(labTech.dateOfJoining.ago)")
                        }
                        HStack {
                            Text("Qualification")
                                .accessibilityLabel("Qualification")
                            Spacer()
                            Text(labTech.qualification)
                                .accessibilityLabel("Qualification: \(labTech.qualification)")
                        }
                        HStack {
                            Text("Experience Since")
                                .accessibilityLabel("Experience Since")
                            Spacer()
                            Text(labTech.experienceSince.ago)
                                .accessibilityLabel("Experience Since: \(labTech.experienceSince.ago)")
                        }
                    }
                }
                
                Form {
                    Section(header: Text("Account Settings")
                        .accessibilityLabel("Account Settings Section")) {
                        NavigationLink(destination: ChangePasswordView(shouldDismiss: true)) {
                            Text("Change Password")
                                .accessibilityLabel("Change Password")
                        }
                    }
                    Section {
                        Button(role: .destructive, action: {
                            showLogoutAlert = true
                        }) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .accessibilityLabel("Log Out")
                                .accessibilityHint("Tap to log out of the account")
                        }
                        .alert(isPresented: $showLogoutAlert) {
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
        .accessibilityLabel("Lab Technician Profile")
        .accessibilityHint("Displays the profile details of the lab technician")
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
