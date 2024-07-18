//
//  LabTechViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import SwiftUI

class LabTechViewModel: ObservableObject {
    @Published var labTests: [LabTest] = []
    @Published var isLoading = false
    @Published var statusCounts: [LabTestStatus: Int] = [:]
    
    @MainActor
    init() {
        fetchLabTests()
    }
    
    @MainActor
    func fetchLabTests(showLoader: Bool = true) {
        Task {
            isLoading = showLoader
            defer {
                isLoading = false
            }
            
            do {
                let labTests = try await LabTest.fetchAll()
                DispatchQueue.main.async {
                    self.labTests = labTests
                    self.updateStatusCounts()
                }
            } catch {
                print("Error fetching lab tests: \(error)")
            }
        }
    }
    
    func updateSampleID(test: LabTest, sampleID: String) async throws {
        let updatedTest = try await test.updateSampleID(sampleID)
        
        DispatchQueue.main.async {
            if let index = self.labTests.firstIndex(where: { $0.id == updatedTest.id }) {
                self.labTests[index] = updatedTest
                self.updateStatusCounts()
            }
        }
    }
    
    func uploadReport(test: LabTest, filePath: URL) async throws {
        let updatedTest = try await test.uploadReport(filePath)
        
        DispatchQueue.main.async {
            if let index = self.labTests.firstIndex(where: { $0.id == updatedTest.id }) {
                self.labTests[index] = updatedTest
                self.updateStatusCounts()
            }
        }
    }
    
    private func updateStatusCounts() {
        var counts: [LabTestStatus: Int] = [:]
        for status in LabTestStatus.allCases {
            counts[status] = labTests.filter { $0.status == status }.count
        }
        self.statusCounts = counts
    }
}
