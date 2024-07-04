//
//  DoctorDetailViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI


class DoctorDetailViewModel: ObservableObject {
    @Published var doctor: Doctor?
    @Published var isLoading = true
    
    
    @MainActor
    init() {
        fetchDoctor()
    }
    
    @MainActor
    func fetchDoctor() {
        Task {
            do {
                let doctor = try await Doctor.getMe()
                self.doctor = doctor
                self.isLoading = false
            } catch {
                print(error)
            }
        
        }
    }
}
