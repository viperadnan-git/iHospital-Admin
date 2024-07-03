//
//  SideBarMenu.swift
//  iHospital Admin
//
//  Created by Aditya on 03/07/24.
//

import SwiftUI

struct SideBarMenu: View {
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
                NavigationLink(destination: Text("Item 3 Detail")) {
                    Label("Patients", systemImage: "person.2")
                }
                NavigationLink(destination: Text("Item 3 Detail")) {
                    Label("Staff", systemImage: "person")
                }
                
                
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("iHospital")
            
        } detail: {
            Dashboard()
        }
    }
}

#Preview {
    SideBarMenu()
}
