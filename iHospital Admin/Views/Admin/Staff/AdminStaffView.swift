//
//  AdminStaffView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 05/07/24.
//

import SwiftUI

enum StaffDepartment: String, CaseIterable, Identifiable, Codable {
    case labTechnician = "lab_technician"
    case nursing = "nursing"
    case housekeeping = "housekeeping"
    case other = "other"

    var id: String { self.rawValue }
    var name: String { self.rawValue.split(separator: "_").joined(separator: " ").capitalized }
    
    var iconName: String {
        switch self {
        case .labTechnician:
            return "flask.fill"
        case .nursing:
            return "stethoscope"
        case .housekeeping:
            return "house.lodge"
        case .other:
            return "building.2.crop.circle"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .labTechnician:
            return Color(uiColor: .brown)
        case .nursing:
            return Color(uiColor: .systemRed)
        case .housekeeping:
            return Color(uiColor: .systemPurple)
        case .other:
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
                    .accessibilityElement()
                    .accessibilityLabel(department.name)
                    .accessibilityHint("Navigates to the list of \(department.name) staff")
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
            Text(department.name)
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

    @State private var searchText = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // Navigated to next slide where list of staff will be shown
    var body: some View {
        VStack {
            if staffViewModel.isLoading {
                CenterSpinner()
            }
            else if staffViewModel.staffs.isEmpty {
                Spacer()
                Image(systemName: "xmark.bin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                    .foregroundColor(Color(.systemGray6))
                    .accessibilityHidden(true)
                
                Text("Tap the + button to add a staff in \(department.name) department")
                    .font(.title2)
                    .foregroundColor(.gray)
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(filteredStaffs) { staff in
                        NavigationLink(destination: AdminStaffInfoView(staffId: staff.id).environmentObject(staffViewModel)) {
                            StaffInfoCard(staffId: staff.id)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(height: 150)
                        .padding(.top, 30)
                        .padding(.horizontal, 4)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .navigationTitle("\(department.name) Staffs")
        .navigationBarItems(trailing: Button(action: {
            showingForm = true
        }) {
            Image(systemName: "plus")
                .font(.title2)
                .accessibilityLabel("Add Staff")
                .accessibilityHint("Tap to add a new staff in \(department.name) department")
        })
        .sheet(isPresented: $showingForm) {
            AdminStaffAddView(staffType: department)
        }
        .onAppear {
            Task {
                do {
                    try await staffViewModel.fetchStaffs(for: department)
                } catch {
                    errorAlertMessage.message = error.localizedDescription
                }
            }
        }
        .environmentObject(staffViewModel)
        .searchable(text: $searchText)
    }
    
    private var filteredStaffs: [Staff] {
        if searchText.isEmpty {
            return staffViewModel.staffs
        } else {
            return staffViewModel.staffs.filter { staff in
                staff.name.lowercased().contains(searchText.lowercased())
                || staff.email.lowercased().contains(searchText.lowercased())
                || staff.phoneNumber.string.contains(searchText.lowercased())
            }
        }
    }
}

// Cards on list of staff page
struct StaffInfoCard: View {
    let staffId: Int
    
    @EnvironmentObject private var staffViewModel: AdminStaffViewModel

    var body: some View {
        if let staff = staffViewModel.staffs.first(where: { $0.id == staffId }) {
            VStack {
                ProfileImage(userId: staff.userId?.uuidString ?? staff.id.string)
                    .foregroundColor(Color(.systemGray))
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.top, 4)
                    .accessibilityHidden(true)
                
                Text(staff.name)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.top, 4)
                    .accessibilityLabel("Name: \(staff.name)")

                HStack(spacing: 2) {
                    Image(systemName: "envelope.fill")
                    Text(staff.email)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .accessibilityLabel("Email: \(staff.email)")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .accessibilityElement(children: .combine)
        }
    }
}

#Preview {
    AdminStaffView()
}
