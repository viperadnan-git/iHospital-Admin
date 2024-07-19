//
//  LabTestTypeViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

class LabTestTypeViewModel: ObservableObject {
    @Published var labTestTypes: [LabTestType] = []
    @Published var isLoading = false
    
    @MainActor
    init() {
        fetchAll()
    }
    
    // Fetches all lab test types
    @MainActor
    func fetchAll(showLoader: Bool = true) {
        Task {
            isLoading = showLoader
            defer {
                isLoading = false
            }
            
            do {
                let labTestTypes = try await LabTestType.fetchAll()
                self.labTestTypes = labTestTypes
            } catch {
                handleFetchError(error)
            }
        }
    }
    
    // Handles errors during fetching lab test types
    private func handleFetchError(_ error: Error) {
        print("Error fetching lab test types: \(error.localizedDescription)")
    }
    
    // Creates a new lab test type
    func new(name: String, price: Int, description: String) async throws {
        _ = try await LabTestType.new(name: name, price: price, description: description)
        await refreshLabTestTypes()
    }
    
    // Saves the updated lab test type details
    func save(labTestType: LabTestType) async throws {
        _ = try await labTestType.save()
        await refreshLabTestTypes()
    }
    
    // Deletes a lab test type
    func delete(labTestType: LabTestType) async throws {
        _ = try await labTestType.delete()
        await refreshLabTestTypes()
    }
    
    // Refreshes the list of lab test types
    @MainActor
    private func refreshLabTestTypes() {
        Task {
            fetchAll(showLoader: false)
        }
    }
}
