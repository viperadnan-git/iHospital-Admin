//
//  SideBarMenu.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

struct AdminSidebarView: View {
    @State private var errorTitle: String?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AdminDashboardView()) {
                    Label("Dashboard", systemImage: "house")
                }
                NavigationLink(destination: AdminAppointmentsList()) {
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
        }.errorAlert(title: $errorTitle, message: $errorMessage)
    }
    
    func onLogOut() {
        Task {
            do {
                print("Loggin out")
                try await SupaUser.logOut()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    AdminSidebarView()
}
