//
//  DoctorView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//

import SwiftUI

struct AdminDepartmentView: View {
    @StateObject private var viewModel = AdminDepartmentViewModel()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                CenterSpinner()
                    .accessibilityLabel("Loading departments")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .accessibilityLabel("Error: \(errorMessage)")
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.departments, id: \.id) { department in
                            NavigationLink(destination: AdminDoctorListView(department: department)) {
                                CardView(department: department)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(height: 150)
                            .padding(.horizontal, 4)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Department: \(department.name)")
                            .accessibilityHint("Tap to view doctors in the \(department.name) department")
                        }
                    }
                    .padding()
                }
            }
        }
        .refreshable {
            viewModel.fetchDepartments(showLoader: false, force: true)
        }
        .navigationTitle("Departments")
        .accessibilityLabel("Departments")
    }
}

struct CardView: View {
    let department: Department
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName(for: department.name))
                    .font(.largeTitle)
                    .padding(.leading, 10)
                    .accessibilityHidden(true)
                Spacer()
            }
            Spacer()
            if let phoneNumber = department.phoneNumber {
                HStack {
                    Image(systemName: "phone.fill")
                    Text(String(phoneNumber))
                        .font(.subheadline)
                        .accessibilityLabel("Phone number: \(phoneNumber)")
                }
            }
            Text(department.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 2)
                .accessibilityLabel(department.name)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(department.hexColor)
        .cornerRadius(15)
        .foregroundColor(.white)
    }
    
    func iconName(for departmentName: String) -> String {
        switch departmentName {
        case "Cardiology":
            return "heart.fill"
        case "Neurology":
            return "brain.head.profile"
        case "Dermatology":
            return "bandage.fill"
        case "Gastroenterology":
            return "stethoscope"
        case "Hematology":
            return "drop.fill"
        case "Infectious Disease":
            return "allergens"
        case "Orthopedics":
            return "figure.walk"
        case "Pediatrics":
            return "stroller"
        case "Radiology":
            return "xmark.shield.fill"
        default:
            return "building.2.crop.circle"
        }
    }
}

#Preview {
    AdminDepartmentView()
}
