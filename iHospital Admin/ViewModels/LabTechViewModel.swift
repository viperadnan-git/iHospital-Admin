//
//  LabTechViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import SwiftUI

class LabTechViewModel: ObservableObject {
    @Published var labTech: Staff? = nil
    @Published var labTests: [LabTest] = []
    @Published var isLoading = true
    @Published var statusCounts: [LabTestStatus: Int] = [:]
    
    @MainActor
    init() {
        fetchInitialData()
    }
    
    @MainActor
    private func fetchInitialData() {
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            async let staff = fetchLabTech()
            async let tests = fetchLabTests()
            
            do {
                let (labTech, labTests) = try await (staff, tests)
                self.labTech = labTech
                self.labTests = labTests
                self.updateStatusCounts()
            } catch {
                print("Error fetching initial data: \(error)")
            }
        }
    }
    
    @MainActor
    private func fetchLabTech() async throws -> Staff {
        do {
            return try await Staff.getMe()
        } catch {
            print("Error fetching lab tech: \(error)")
            throw error
        }
    }
    
    @MainActor
    private func fetchLabTests() async throws -> [LabTest] {
        do {
            return try await LabTest.fetchAll()
        } catch {
            throw error
        }
    }
    
    func updateLabTests(showLoader: Bool = true) {
        isLoading = true
        defer { isLoading = false }
        
        Task {
            do {
                let labTests = try await fetchLabTests()
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
