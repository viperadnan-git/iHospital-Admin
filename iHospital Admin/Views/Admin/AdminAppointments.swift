//
//  AdminAppointmentsList.swift
//  iHospital Admin
//
//  Created by Aditya on 04/07/24.
//

import SwiftUI

struct AdminAppointments: View {
    @State private var selectedDate = Date()
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            HStack{
                SearchBar(text: $searchText)
                    .padding()

            }
            ScrollView{
                AdminAppointmentsList(searchText: $searchText)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
            }
            
        }
        .navigationTitle("Appointments")
    }
}





#Preview {
    AdminAppointments()
}