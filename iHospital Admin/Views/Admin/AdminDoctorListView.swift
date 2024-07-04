//
//  DoctorView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//

import SwiftUI

struct AdminDoctorListView: View {
    let department: Department
    
    var body: some View {
        VStack {
            Text("List of doctors in \(department.name)")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle(department.name)
        .navigationBarItems(trailing: Button(action: {
            // Action for Plus button
            print("Plus button tapped")
        }) {
            Image(systemName: "plus")
                .font(.title3)
        })
    }
}
