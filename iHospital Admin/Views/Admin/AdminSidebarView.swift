//
//  SideBarMenu.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

struct AdminSidebarView: View {
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    @State private var selection: String? = "Dashboard"
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: "Dashboard") {
                    Label("Dashboard", systemImage: selection == "Dashboard" ? "house.fill" : "house")
                        .accessibilityLabel("Dashboard")
                        .accessibilityHint("Go to Dashboard")
                }
                NavigationLink(value: "Appointments") {
                    Label("Appointments", systemImage: "calendar")
                        .accessibilityLabel("Appointments")
                        .accessibilityHint("Go to Appointments")
                }
                NavigationLink(value: "Doctors") {
                    Label("Doctors", systemImage: selection == "Doctors" ? "stethoscope.circle.fill" : "stethoscope.circle")
                        .accessibilityLabel("Doctors")
                        .accessibilityHint("Go to Doctors")
                }
                NavigationLink(value: "Patients") {
                    Label("Patients", systemImage: selection == "Patients" ? "person.2.fill" : "person.2")
                        .accessibilityLabel("Patients")
                        .accessibilityHint("Go to Patients")
                }
                NavigationLink(value: "Staff") {
                    Label("Staff", systemImage: selection == "Staff" ? "person.fill" : "person")
                        .accessibilityLabel("Staff")
                        .accessibilityHint("Go to Staff")
                }
                NavigationLink(value: "Lab Test") {
                    Label("Lab Test", systemImage: selection == "Lab Test" ? "flask.fill" : "flask")
                        .accessibilityLabel("Lab Test")
                        .accessibilityHint("Go to Lab Test")
                }
                NavigationLink(value: "Bed Management") {
                    Label("Bed Management", systemImage: selection == "Bed Management" ? "bed.double.fill" : "bed.double")
                        .accessibilityLabel("Bed Management")
                        .accessibilityHint("Go to Bed Management")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("iHospital")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                            Text("Logout")
                        }
                        .foregroundStyle(.red)
                        .accessibilityLabel("Logout")
                        .accessibilityHint("Tap to logout")
                    }
                }
            }
        } detail: {
            NavigationStack {
                if let selection = selection {
                    switch selection {
                    case "Dashboard":
                        AdminDashboardView()
                            .accessibilityLabel("Dashboard View")
                    case "Appointments":
                        AdminAppointmentsTable()
                            .accessibilityLabel("Appointments Table View")
                    case "Doctors":
                        AdminDepartmentView()
                            .accessibilityLabel("Doctors List View")
                    case "Patients":
                        AdminPatientView()
                            .accessibilityLabel("Patients List View")
                    case "Staff":
                        AdminStaffView()
                            .accessibilityLabel("Staff List View")
                    case "Lab Test":
                        AdminLabTechTypeView()
                            .accessibilityLabel("Lab Tests List View")
                    case "Bed Management":
                        AdminBedView()
                            .accessibilityLabel("Bed Management View")
                    default:
                        AdminDashboardView()
                            .accessibilityLabel("Dashboard View")
                    }
                } else {
                    AdminDashboardView()
                        .accessibilityLabel("Dashboard View")
                }
            }
        }
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout")) {
                    onLogout()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func onLogout() {
        Task {
            do {
                print("Logging out")
                try await SupaUser.logout()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    AdminSidebarView()
}
