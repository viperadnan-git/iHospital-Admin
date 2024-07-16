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
    
    init() {
        fetchAll()
    }
    
    func fetchAll()  {
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                labTestTypes = try await LabTestType.fetchAll()
            } catch {
                print("Error fetching lab test types: \(error)")
            }
        }
    }
    
    func new(name: String, price: Int, description: String) async throws {
        _ = try await LabTestType.new(name: name, price: price, description: description)
        fetchAll()
    }
    
    func save(labTestType: LabTestType) async throws {
        _ = try await labTestType.save()
        fetchAll()
    }
    
    func delete(labTestType: LabTestType) async throws {
        _ = try await labTestType.delete()
        fetchAll()
    }
}
