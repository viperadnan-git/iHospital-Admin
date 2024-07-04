//
//  DoctorView.swift
//  iHospital Admin
//
//  Created by AKANKSHA on 04/07/24.
//

import SwiftUI

struct AdminDoctorListView: View {
    let department: Department
    
    @State private var showingForm = false
    
    var body: some View {
        VStack {
            Text("List of doctors in \(department.name)")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle(department.name)
        .navigationBarItems(trailing: Button(action: {
            showingForm = true
            print("Plus button tapped")
        }) {
            Image(systemName: "plus")
                .font(.title3)
        })
        .sheet(isPresented: $showingForm) {
                   AdminDoctorAddView()
               }
    }
}




