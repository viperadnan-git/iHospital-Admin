//
//  AdminDoctorViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI
import Combine

class AdminDoctorViewModel: ObservableObject {
    @Published var departments: [Department] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        fetchDepartments()
    }
    
    func fetchDepartments() {
        isLoading = true
        Task {
            do {
                let fetchedDepartments = try await Department.fetchAll()
                DispatchQueue.main.async {
                    self.departments = fetchedDepartments
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load departments"
                    self.isLoading = false
                }
            }
        }
    }
}
