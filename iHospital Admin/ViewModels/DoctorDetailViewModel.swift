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
    
    init() {
        fetchDoctor()
    }
    
    func fetchDoctor() {
        Task {
            do {
                let doctor = try await Doctor.getMe()
                DispatchQueue.main.async {
                    self.doctor = doctor
                    self.isLoading = false
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchAppointments() {
        guard let doctor = doctor else {
            return
        }
        
        Task {
            do {
                let appointments = try await doctor.fetchAppointments()
                DispatchQueue.main.async {
                    self.appointments = appointments
                    print(appointments)
                }
            } catch {
                print(error)
            }
        }
    }
}
