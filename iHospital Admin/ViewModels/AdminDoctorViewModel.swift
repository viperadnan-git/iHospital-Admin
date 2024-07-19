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
    
    private var cached: [Doctor] = []
    
    // Fetches the list of doctors for a specific department
    @MainActor
    func fetchDoctors(department: Department, showLoader: Bool = true, force: Bool = false) {
        if !force, !cached.isEmpty {
            doctors = cached
            return
        }

        Task {
            self.isLoading = showLoader
            defer {
                isLoading = false
            }
            
            do {
                let fetchedDoctors = try await Doctor.fetchDepartmentWise(departmentId: department.id)
                DispatchQueue.main.async {
                    self.doctors = fetchedDoctors
                    self.cached = fetchedDoctors
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Adds a new doctor and updates the list
    func new(doctor: Doctor) async throws {
        let doctor = try await Doctor.new(doctor: doctor)
        DispatchQueue.main.async {
            self.doctors.append(doctor)
            self.cached = self.doctors
        }
    }
}
