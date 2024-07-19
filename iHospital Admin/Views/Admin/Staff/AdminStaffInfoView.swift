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
                        .accessibilityHidden(true)
                    
                    Text(staff.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .accessibilityLabel("Name: \(staff.name)")
                }
                
                Section(header: Text("Staff Information").accessibilityAddTraits(.isHeader)) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(staff.name)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Name")
                    .accessibilityValue(staff.name)
                    
                    HStack {
                        Text("Date of Birth")
                        Spacer()
                        Text(DateFormatter.dateFormatter.string(from: staff.dateOfBirth))
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Date of Birth")
                    .accessibilityValue(DateFormatter.dateFormatter.string(from: staff.dateOfBirth))
                    
                    HStack {
                        Text("Gender")
                        Spacer()
                        Text(staff.gender.rawValue.capitalized)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Gender")
                    .accessibilityValue(staff.gender.rawValue.capitalized)
                    
                    HStack {
                        Text("Phone Number")
                        Spacer()
                        Text("\(staff.phoneNumber)")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Phone Number")
                    .accessibilityValue("\(staff.phoneNumber)")
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(staff.email)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Email")
                    .accessibilityValue(staff.email)
                    
                    HStack {
                        Text("Qualification")
                        Spacer()
                        Text(staff.qualification)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Qualification")
                    .accessibilityValue(staff.qualification)
                    
                    HStack {
                        Text("Experience Since")
                        Spacer()
                        Text(DateFormatter.dateFormatter.string(from: staff.experienceSince))
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Experience Since")
                    .accessibilityValue(DateFormatter.dateFormatter.string(from: staff.experienceSince))
                    
                    HStack {
                        Text("Date of Joining")
                        Spacer()
                        Text(DateFormatter.dateFormatter.string(from: staff.dateOfJoining))
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Date of Joining")
                    .accessibilityValue(DateFormatter.dateFormatter.string(from: staff.dateOfJoining))
                    
                    HStack {
                        Text("Address")
                        Spacer()
                        Text(staff.address)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Address")
                    .accessibilityValue(staff.address)
                }
                Button(role: .destructive) {
                    showAlert.toggle()
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .accessibilityLabel("Delete Staff")
                .accessibilityHint("Tap to delete this staff")
                .alert(isPresented: $showAlert, content: {
                    Alert(
                        title: Text("Delete Staff"),
                        message: Text("Are you sure you want to delete this staff?"),
                        primaryButton: .destructive(Text("Delete"), action: {
                            deleteStaff()
                        }),
                        secondaryButton: .cancel()
                    )
                })
                
            }
            .navigationTitle("Staff Details")
            .navigationBarItems(trailing: Button("Edit") {
                isEditMode = true
            }
            .accessibilityLabel("Edit Staff")
            .accessibilityHint("Tap to edit the staff details")
            )
            .sheet(isPresented: $isEditMode) {
                AdminStaffAddView(staffType: staff.type, staffId: staff.id)
            }
        }
    }
    
    private func deleteStaff() {
        print("Deleted Successfully")
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AdminStaffInfoView(staffId: Staff.sample.id)
}
