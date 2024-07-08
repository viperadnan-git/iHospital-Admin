//
//  AdminDoctorViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI
import Combine

class AdminDepartmentViewModel: ObservableObject {
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
                print(fetchedDepartments)
                DispatchQueue.main.async {
                    self.departments = fetchedDepartments
                    self.isLoading = false
                }
            } catch {
                print(error)
            }
        }
    }
}
