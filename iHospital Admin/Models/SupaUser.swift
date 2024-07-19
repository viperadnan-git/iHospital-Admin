//
//  SupaUser.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Auth
import Foundation

struct SupaUser: Codable {
    static var shared = loadUser() {
        didSet {
            if let shared = shared {
                shared.saveUser()
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.userInfoKey)
            }
        }
    }
    
    let user: Auth.User
    let role: Roles
    
    static let sample: SupaUser = SupaUser(user: Auth.User(id: UUID(), appMetadata: [:], userMetadata: [:], aud: "", createdAt: Date(), updatedAt: Date()), role: .admin)
    
    // Loads the user from UserDefaults
    static func loadUser() -> SupaUser? {
        guard let data = UserDefaults.standard.data(forKey: Constants.userInfoKey) else {
            print("User data not found")
            return nil
        }
        
        let decoder = JSONDecoder()
        if let user = try? decoder.decode(SupaUser.self, from: data) {
            return user
        }
        
        return nil
    }
    
    // Saves the user to UserDefaults
    func saveUser() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            UserDefaults.standard.set(data, forKey: Constants.userInfoKey)
        }
    }
    
    // Logs in the user using email and password
    static func login(email: String, password: String) async throws {
        try await supabase.auth.signIn(email: email, password: password)
    }
    
    // Logs out the current user
    static func logout() async throws {
        try await supabase.auth.signOut()
        shared = nil
    }
    
    // Fetches the SupaUser from the database
    static func getSupaUser() async throws -> SupaUser? {
        guard let user = supabase.auth.currentUser else {
            return nil
        }
        
        let role: [String: Roles] = try await supabase.from(SupabaseTable.roles.id)
            .select("role")
            .eq("user_id", value: user.id)
            .single()
            .execute()
            .value
        
        print("Logged in as \(user.email ?? "Unknown email") with role \(role["role"]?.rawValue ?? "Unknown role")")
        return SupaUser(user: user, role: role["role"]!)
    }
    
    // Updates the user's password
    func updatePassword(password: String) async throws {
        try await supabase.auth.update(user: UserAttributes(password: password))
    }
}
