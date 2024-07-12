//
//  SideBarMenu.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

struct AdminSidebarView: View {
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AdminDashboardView()) {
                    Label("Dashboard", systemImage: "house")
                }
                NavigationLink(destination: AdminAppointmentsTable()) {
                    Label("Appointments", systemImage: "calendar")
                }
                NavigationLink(destination: AdminDepartmentView()) {
                    Label("Doctors", systemImage: "stethoscope")
                }
                NavigationLink(destination: AdminPatientView()) {
                    Label("Patients", systemImage: "person.2")
                }
                NavigationLink(destination: AdminStaffView()
                ) {
                    Label("Staff", systemImage: "person")
                }
                NavigationLink(destination: AdminBedView()
                ) {
                    Label("Bed Management", systemImage: "bed.double")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("iHospital")
            // logout button on bottom
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: onLogOut) {
                        Text("Logout")
                        Image(systemName: "arrow.left.square")
                    }
                }
            }
            AdminDashboardView()
        }.errorAlert(errorAlertMessage: errorAlertMessage)
    }
    
    func onLogOut() {
        Task {
            do {
                print("Logging out")
                try await SupaUser.logOut()
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    AdminSidebarView()
}
