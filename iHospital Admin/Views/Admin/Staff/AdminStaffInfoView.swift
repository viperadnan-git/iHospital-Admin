//
//  AdminStaffInfoView.swift
//  iHospital Admin
//
//  Created by Aditya on 12/07/24.
//

import SwiftUI

struct AdminStaffInfoView: View {
    let staffId: Int
    
    @State private var isEditMode: Bool = false
    @State private var showAlert: Bool = false
    
    @EnvironmentObject var staffViewModel: AdminStaffViewModel
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        if let staff = staffViewModel.staffs.first(where: { $0.id == staffId }) {
            Form {
                VStack {
                    ProfileImageChangeable(userId: staff.userId?.uuidString ?? staff.id.string)
                    
                    Text(staff.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                }
                
                Section(header: Text("Staff Information")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(staff.name)
                    }
                    HStack {
                        Text("Date of Birth")
                        Spacer()
                        Text(DateFormatter.dateFormatter.string(from: staff.dateOfBirth))
                    }
                    HStack {
                        Text("Gender")
                        Spacer()
                        Text(staff.gender.rawValue.capitalized)
                    }
                    HStack {
                        Text("Phone Number")
                        Spacer()
                        Text("\(staff.phoneNumber)")
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(staff.email)
                    }
                    HStack {
                        Text("Qualification")
                        Spacer()
                        Text(staff.qualification)
                    }
                    HStack {
                        Text("Experience Since")
                        Spacer()
                        Text(DateFormatter.dateFormatter.string(from: staff.experienceSince))
                    }
                    HStack {
                        Text("Date of Joining")
                        Spacer()
                        Text(DateFormatter.dateFormatter.string(from: staff.dateOfJoining))
                    }
                    HStack {
                        Text("Address")
                        Spacer()
                        Text(staff.address)
                    }
              
                }
                Button(role: .destructive) {
                    showAlert.toggle()
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity,alignment: .center)
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Delete Staff"), message: Text("Are you sure you want to delete this staff?"), primaryButton: .destructive(Text("Delete"),action: {
                        deleteStaff()
                    }), secondaryButton: .cancel())
                })
                
            }.navigationTitle("Staff Details")
                .navigationBarItems(trailing: Button("Edit") {
                    isEditMode = true
                })
                .sheet(isPresented: $isEditMode) {
                    AdminStaffAddView(staffType: staff.type, staffId: staff.id)
                }
        }
    }
    private func deleteStaff() {
        print("Deleted Succefully")
        presentationMode.wrappedValue.dismiss()

    }
}

#Preview {
    AdminStaffInfoView(staffId: Staff.sample.id)
}
