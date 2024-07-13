//
//  AdminStaffView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 05/07/24.
//

import SwiftUI

enum StaffDepartment: String, CaseIterable, Identifiable, Codable {
    case clinicalLaboratory = "clinical laboratory"
    case nursing = "nursing"
    case housekeeping = "housekeeping"
    case others = "others"

    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .clinicalLaboratory:
            return "cross.case"
        case .nursing:
            return "stethoscope"
        case .housekeeping:
            return "house.lodge"
        case .others:
            return "building.2.crop.circle"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .clinicalLaboratory:
            return Color(uiColor: .brown)
        case .nursing:
            return Color(uiColor: .systemRed)
        case .housekeeping:
            return Color(uiColor: .systemPurple)
        case .others:
            return Color(uiColor: .systemOrange)
        }
    }
}

struct AdminStaffView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(StaffDepartment.allCases) { department in
                    NavigationLink(destination: AdminStaffListView(department: department)) {
                        StaffDepartmentCard(department: department)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 150)
                    .padding(.horizontal, 4)
                }
            }
            .padding()
        }
        .navigationTitle("Staff Departments")
    }
}

struct StaffDepartmentCard: View {
    let department: StaffDepartment

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: department.iconName)
                    .font(.largeTitle)
                    .padding(.leading, 10)
                Spacer()
            }
            Spacer()
            Text(department.rawValue.capitalized)
                .font(.title)
                .fontWeight(.bold)
                
        }
        .foregroundColor(Color(uiColor: .white))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(department.backgroundColor)
        .cornerRadius(10)
    }
}

struct AdminStaffListView: View {
    let department: StaffDepartment

    @StateObject private var staffViewModel = AdminStaffViewModel()
    @State private var showingForm = false
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to fetch staffs")

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // Navigated to next slide where list of staff will be shown
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(staffViewModel.staffs) { staff in
                    NavigationLink(destination: StaffDetailed(staff: staff)) {
                        StaffInfoCard(staff: staff)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 150)
                    .padding(.all)
                }
            }
            .padding()
        }
        .navigationTitle("Staff List")
        .navigationBarItems(trailing: Button(action: {
            showingForm = true
        }) {
            Image(systemName: "plus")
                .font(.title2)
        })
        .sheet(isPresented: $showingForm) {
            AdminStaffAddView(staffType: department)
        }.onAppear {
            Task {
                do {
                    try await staffViewModel.fetchStaffs(for: department)
                } catch {
                    errorAlertMessage.message = error.localizedDescription
                }
                
            }
        }
        .environmentObject(staffViewModel)
    }
}

// Cards on list of staff page
struct StaffInfoCard: View {
    let staff: Staff

    var body: some View {
        VStack {
            Text(staff.name)
                .font(.headline)
            Text(staff.email)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
    }
}

// Profile detail page of staff
struct StaffDetailed: View {
    let staff: Staff

    @State private var showingForm = false

    var body: some View {
        VStack {
            Text("Profile \(staff.name)")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("Profile")
        .navigationBarItems(trailing: Button(action: {
            showingForm = true
        }) {
            Text("Edit")
                .font(.title2)
        })
    }
}

#Preview {
    AdminStaffView()
}
