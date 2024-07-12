//
//  AdminStaffInfoView.swift
//  iHospital Admin
//
//  Created by Aditya on 12/07/24.
//

import SwiftUI

struct AdminStaffInfoView: View {
    var body: some View {
        Form {
            VStack{
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                    .foregroundColor(Color(.systemGray))
                    .frame(maxWidth: .infinity)
                
                Text("Staff Name")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
            
            Section(header: Text("Staff Information")) {
                
                
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Staff Name")
                }
                HStack {
                    Text("Date of Birth")
                    Spacer()
                    Text("Date of Birth")
                }
                HStack {
                    Text("Gender")
                    Spacer()
                    Text("Gender")
                }
                HStack {
                    Text("Phone Number")
                    Spacer()
                    Text("Phone Number")
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text("Email")
                }
                HStack {
                    Text("Qualification")
                    Spacer()
                    Text("Qualification")
                }
                HStack {
                    Text("Experience Since")
                    Spacer()
                    Text("Experience Since")
                }
                HStack {
                    Text("Date of Joining")
                    Spacer()
                    Text("Date of Joining")
                }
            }
        }
    }
}

#Preview {
    AdminStaffInfoView()
}
