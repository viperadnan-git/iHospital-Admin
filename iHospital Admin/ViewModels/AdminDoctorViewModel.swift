//
//  AdminDoctorViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//


import SwiftUI
import Combine

class AdminDoctorViewModel: ObservableObject {
    @Published var doctors: [Doctor] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchDoctors(department: Department) {
        isLoading = true
        Task {
            do {
                let fetchedDoctors = try await Doctor.fetchDepartmentWise(departmentId: department.id)
                DispatchQueue.main.async {
                    self.doctors = fetchedDoctors
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
