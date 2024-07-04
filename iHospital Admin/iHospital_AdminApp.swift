//
//  iHospital_AdminApp.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 03/07/24.
//

import SwiftUI

@main
struct iHospital_AdminApp: App {
    @State private var isAuthenticated: Bool = SupaUser.shared != nil
    
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    if true {
                        AdminSidebarView()
                    } else {
                        DoctorSide()
                    }
                }
                else {
                    LoginView()
                }
            }.task {
                for await state in supabase.auth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                    }
                }
            }
        }
    }
}
