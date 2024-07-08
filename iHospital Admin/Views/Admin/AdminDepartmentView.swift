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
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
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
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Departments")
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
                Spacer()
            }
            Spacer()
            if let phoneNumber = department.phoneNumber {
                HStack {
                    Image(systemName: "phone.fill")
                    Text(String(phoneNumber))
                        .font(.subheadline)
                }
            }
            Text(department.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(backgroundColor(for: department.name))
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
    
    func backgroundColor(for departmentName: String) -> Color {
        switch departmentName {
        case "Cardiology":
            return Color.red
        case "Neurology":
            return Color.purple
        case "Dermatology":
            return Color.orange
        case "Gastroenterology":
            return Color.green
        case "Hematology":
            return Color.red.opacity(0.8)
        case "Infectious Disease":
            return Color.yellow
        case "Orthopedics":
            return Color.blue
        case "Pediatrics":
            return Color.pink
        case "Radiology":
            return Color.gray
        default:
            return Color.blue.opacity(0.5)
        }
    }
}


#Preview {
    AdminDepartmentView()
}

