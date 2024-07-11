//
//  PatientViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

class PatientViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    @Published var isLoading: Bool = false
    
    @MainActor
    init() {
        fetchPatients()
    }
    
    @MainActor
    func fetchPatients(showLoader: Bool = true) {
        Task {
            isLoading = showLoader
            defer {
                isLoading = false
            }
            
            do {
                let fetchedPatients = try await Patient.fetchAll()
                DispatchQueue.main.async {
                    self.patients = fetchedPatients
                }
            } catch {
                print("Error fetching patients: \(error.localizedDescription)")
            }
        }
    }
}
