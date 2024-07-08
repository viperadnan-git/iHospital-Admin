//
//  iHospital_AdminApp.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI
import Auth

@main
struct iHospital_AdminApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.user != nil {
                    if authViewModel.shouldChangePassword {
                        ChangePasswordView()
                    } else if authViewModel.user?.role == .admin {
                        AdminSidebarView()
                    } else {
                        DoctorDashboardView()
                    }
                }
                else {
                    LoginView()
                }
            }.environmentObject(authViewModel)
        }
    }
}
