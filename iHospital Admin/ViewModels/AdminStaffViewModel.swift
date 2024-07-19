//
//  AdminStaffViewModel.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 14/07/24.
//

import Foundation
import Combine

class AdminStaffViewModel: ObservableObject {
    @Published var staffs: [Staff] = []
    @Published var isLoading: Bool = false
    @Published var selectedStaff: Staff?
    
    private var cancellables = Set<AnyCancellable>()
    
    // Fetches the list of staff for a specific department
    @MainActor
    func fetchStaffs(for department: StaffDepartment) async throws {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            let fetchedStaffs = try await Staff.fetchAllStaff(for: department)
            self.staffs = fetchedStaffs
        } catch {
            print("Error fetching staffs: \(error.localizedDescription)")
        }
    }
    
    // Creates a new staff member
    @MainActor
    func newStaff(firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, email: String, phoneNumber: Int, address: String, dateOfJoining: Date, qualification: String, experienceSince: Date, type: StaffDepartment) async throws {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            let newStaff = try await Staff.new(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, email: email, phoneNumber: phoneNumber, address: address, dateOfJoining: dateOfJoining, qualification: qualification, experienceSince: experienceSince, type: type)
            self.staffs.append(newStaff)
        } catch {
            print("Error creating new staff: \(error.localizedDescription)")
        }
    }
    
    // Saves the updated details of a staff member
    @MainActor
    func save(staff: Staff) async throws {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            try await staff.save()
            if let index = self.staffs.firstIndex(where: { $0.id == staff.id }) {
                self.staffs[index] = staff
            }
        } catch {
            print("Error saving staff: \(error.localizedDescription)")
        }
    }
}
