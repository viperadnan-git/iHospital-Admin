//
//  User.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Auth
import Foundation

struct SupaUser: Codable {
    static var shared = loadUser() {
        didSet {
            shared?.saveUser()
        }
    }
    
    let user: Auth.User
    let role: Role
    
    static func loadUser() -> SupaUser? {
        guard let data = UserDefaults.standard.data(forKey: USER_INFO_KEY) else {
            print("User data found")
            return nil
        }
        
        let decoder = JSONDecoder()
        if let user = try? decoder.decode(SupaUser.self, from: data) {
            return user
        }
        
        return nil
    }
    
    func saveUser() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            UserDefaults.standard.set(data, forKey: USER_INFO_KEY)
        }
    }
    
    static func login(email: String, password: String) async throws -> SupaUser? {
        let response = try await supabase.auth.signIn(email: email, password: password)
        
        let role: [String: Role] = try await supabase.from(SupabaseTable.roles.rawValue)
            .select("role")
            .eq("user_id", value: response.user.id)
            .single()
            .execute()
            .value
        
        let supaUser = SupaUser(user: response.user, role: role["role"]!)
        
        SupaUser.shared = supaUser
        return supaUser
    }
}
