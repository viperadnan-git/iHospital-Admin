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
                            .padding(.all)
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
        VStack {
            Text(department.name)
                .font(.headline)
            if let phoneNumber = department.phoneNumber {
                Text("Phone: \(phoneNumber)")
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
    }
}



#Preview {
    AdminSidebarView()
}
