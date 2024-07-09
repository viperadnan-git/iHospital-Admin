//
//  DoctorDetailViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import SwiftUI


class DoctorDetailViewModel: ObservableObject {
    @Published var doctor: Doctor?
    @Published var appointments: [Appointment] = []
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
                print("Error fetching current doctor: \(error)")
                try await SupaUser.logOut()
            }
        }
    }
    
    func fetchAppointments(for date: Date) {
        guard let doctor = doctor else {
            return
        }
        
        Task {
            do {
                let appointments = try await doctor.fetchAppointments(for: date)
                DispatchQueue.main.async {
                    self.appointments = appointments
                }
            } catch {
                print("Error fetching appointments: \(error)")
            }
        }
    }
}
