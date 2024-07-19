//
//  AuthViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI
import Supabase

class AuthViewModel: ObservableObject {
    @Published var user: SupaUser? = SupaUser.shared
    @Published var shouldChangePassword: Bool = false
    
    @MainActor
    init() {
        // Listen for authentication state changes
        Task {
            await monitorAuthStateChanges()
        }
    }
    
    // Monitors authentication state changes and updates the user accordingly
    @MainActor
    private func monitorAuthStateChanges() async {
        for await state in supabase.auth.authStateChanges {
            if [.initialSession, .signedOut].contains(state.event) {
                do {
                    try await updateSupaUser()
                } catch {
                    print("Error updating user: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Updates the SupaUser instance with the current authenticated user
    @MainActor
    func updateSupaUser() async throws {
        let user = try await SupaUser.getSupaUser()
        SupaUser.shared = user
        self.user = user
    }
}
