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
    
    @MainActor
    func fetchStaffs(for department: StaffDepartment) async throws {
        isLoading = true
        
        let fetchedStaffs = try await Staff.fetchAllStaff(for: department)
        DispatchQueue.main.async {
            self.staffs = fetchedStaffs
            self.isLoading = false
        }
    }
    
    @MainActor
    func newStaff(firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, email: String, phoneNumber: Int, address: String, dateOfJoining: Date, qualification: String, experienceSince: Date, type: StaffDepartment) async throws {
        isLoading = true
        
        let newStaff = try await Staff.new(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, email: email, phoneNumber: phoneNumber, address: address, dateOfJoining: dateOfJoining, qualification: qualification, experienceSince: experienceSince, type: type)
        DispatchQueue.main.async {
            self.staffs.append(newStaff)
            self.isLoading = false
        }
    }
    
    @MainActor
    func save(staff: Staff) async throws {
        isLoading = true
        
        try await staff.save()
        DispatchQueue.main.async {
            if let index = self.staffs.firstIndex(where: { $0.id == staff.id }) {
                self.staffs[index] = staff
            }
            self.isLoading = false
        }
    }
}
