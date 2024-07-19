import SwiftUI

struct DoctorDetailsColumn: View {
    @EnvironmentObject var doctorDetailViewModel: DoctorViewModel
    
    @StateObject var errorAlertMessage = ErrorAlertMessage()
    @State private var showLogoutAlert = false
    
    var body: some View {
        Group {
            if let doctor = doctorDetailViewModel.doctor {
                Form {
                    // Profile Image Section
                    Section {
                        ProfileImageChangeable(userId: doctor.userId.uuidString)
                            .accessibility(label: Text("Doctor Profile Picture"))
                    }
                    
                    // Doctor Details Section
                    Section(header: Text("Doctor Details")) {
                        Text(doctor.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                            .accessibility(label: Text("Doctor's Name"))

                        HStack {
                            Text("Email")
                                .accessibility(label: Text("Email"))
                            Spacer()
                            Text(doctor.email)
                                .accessibility(value: Text(doctor.email))
                        }

                        HStack {
                            Text("Gender")
                                .accessibility(label: Text("Gender"))
                            Spacer()
                            Text(doctor.gender.id.capitalized)
                                .accessibility(value: Text(doctor.gender.id.capitalized))
                        }

                        HStack {
                            Text("Phone")
                                .accessibility(label: Text("Phone Number"))
                            Spacer()
                            Text(String(doctor.phoneNumber))
                                .accessibility(value: Text(String(doctor.phoneNumber)))
                        }

                        HStack {
                            Text("Qualification")
                                .accessibility(label: Text("Qualification"))
                            Spacer()
                            Text(doctor.qualification)
                                .accessibility(value: Text(doctor.qualification))
                        }

                        HStack {
                            Text("Year of Experience")
                                .accessibility(label: Text("Year of Experience"))
                            Spacer()
                            Text(doctor.experienceSince.ago)
                                .accessibility(value: Text(doctor.experienceSince.ago))
                        }

                        HStack {
                            Text("Date of Joining")
                                .accessibility(label: Text("Date of Joining"))
                            Spacer()
                            Text(doctor.dateOfJoining.dateString)
                                .accessibility(value: Text(doctor.dateOfJoining.dateString))
                        }

                        HStack {
                            Text("Fee")
                                .accessibility(label: Text("Fee"))
                            Spacer()
                            Text(doctor.fee.formatted(.currency(code: Constants.currencyCode)))
                                .accessibility(value: Text(doctor.fee.formatted(.currency(code: Constants.currencyCode))))
                        }
                    }
                    
                    // Account Settings Section
                    Section(header: Text("Account Settings")) {
                        NavigationLink(destination: ChangePasswordView(shouldDismiss: true)) {
                            Text("Change Password")
                        }
                    }
                    
                    // Log Out Section
                    Section {
                        Button(role: .destructive, action: {
                            showLogoutAlert = true
                        }) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity, alignment: .center)
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
                .errorAlert(errorAlertMessage: errorAlertMessage)
            } else {
                CenterSpinner()
            }
        }
        .accessibilityElement(children: .combine)
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
