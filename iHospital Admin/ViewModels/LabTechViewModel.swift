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
    
    // Fetches initial data for the lab technician
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
    
    // Fetches the lab technician details
    @MainActor
    private func fetchLabTech() async throws -> Staff {
        do {
            return try await Staff.getMe()
        } catch {
            print("Error fetching lab tech: \(error)")
            throw error
        }
    }
    
    // Fetches all lab tests
    @MainActor
    private func fetchLabTests() async throws -> [LabTest] {
        do {
            return try await LabTest.fetchAll()
        } catch {
            print("Error fetching lab tests: \(error)")
            throw error
        }
    }
    
    // Updates the list of lab tests
    func updateLabTests(showLoader: Bool = true) {
        isLoading = showLoader
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
    
    // Updates the sample ID for a lab test
    func updateSampleID(test: LabTest, sampleID: String) async throws {
        let updatedTest = try await test.updateSampleID(sampleID)
        
        DispatchQueue.main.async {
            if let index = self.labTests.firstIndex(where: { $0.id == updatedTest.id }) {
                self.labTests[index] = updatedTest
                self.updateStatusCounts()
            }
        }
    }
    
    // Uploads a report for a lab test
    func uploadReport(test: LabTest, filePath: URL) async throws {
        let updatedTest = try await test.uploadReport(filePath)
        
        DispatchQueue.main.async {
            if let index = self.labTests.firstIndex(where: { $0.id == updatedTest.id }) {
                self.labTests[index] = updatedTest
                self.updateStatusCounts()
            }
        }
    }
    
    // Updates the counts of lab test statuses
    private func updateStatusCounts() {
        var counts: [LabTestStatus: Int] = [:]
        for status in LabTestStatus.allCases {
            counts[status] = labTests.filter { $0.status == status }.count
        }
        self.statusCounts = counts
    }
}
