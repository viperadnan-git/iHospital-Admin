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
                }
                NavigationLink(value: "Appointments") {
                    Label("Appointments", systemImage: "calendar")
                }
                NavigationLink(value: "Doctors") {
                    Label("Doctors", systemImage: selection == "Doctors" ? "stethoscope.circle.fill" : "stethoscope.circle")
                }
                NavigationLink(value: "Patients") {
                    Label("Patients", systemImage: selection == "Patients" ? "person.2.fill" : "person.2")
                }
                NavigationLink(value: "Staff") {
                    Label("Staff", systemImage: selection == "Staff" ? "person.fill" : "person")
                }
                NavigationLink(value: "Lab Test") {
                    Label("Lab Test", systemImage: selection == "Lab Test" ? "flask.fill" : "flask")
                }
                NavigationLink(value: "Bed Management") {
                    Label("Bed Management", systemImage: selection == "Bed Management" ? "bed.double.fill" : "bed.double")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("iHospital")
            .onAppear {
                selection = "Dashboard"
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                            Text("Logout")
                        }.foregroundStyle(.red)
                    }
                }
            }
        } detail: {
            NavigationStack {
                if let selection = selection {
                    switch selection {
                    case "Dashboard":
                        AdminDashboardView()
                    case "Appointments":
                        AdminAppointmentsTable()
                    case "Doctors":
                        AdminDepartmentView()
                    case "Patients":
                        AdminPatientView()
                    case "Staff":
                        AdminStaffView()
                    case "Lab Test":
                        AdminLabTechTypeView()
                    case "Bed Management":
                        AdminBedView()
                    default:
                        AdminDashboardView()
                    }
                } else {
                    AdminDashboardView()
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
