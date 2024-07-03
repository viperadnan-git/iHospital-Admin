//
//  SideBarMenu.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

struct SideBarMenu: View {
    @State private var errorTitle: String?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: Dashboard()) {
                    Label("Dashboard", systemImage: "house")
                }
                NavigationLink(destination: Text("Item 2 Detail")) {
                    Label("Appointments", systemImage: "calendar")
                }
                NavigationLink(destination: Text("Item 3 Detail")) {
                    Label("Doctors", systemImage: "stethoscope")
                }
                NavigationLink(destination: Text("Item 4 Detail")) {
                    Label("Patients", systemImage: "person.2")
                }
                NavigationLink(destination: Text("Item 5 Detail")) {
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
        } detail: {
            Dashboard()
        }.errorAlert(title: $errorTitle, message: $errorMessage)
    }
    
    func onLogOut() {
        Task {
            do {
                try await supabase.auth.signOut()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    SideBarMenu()
}
