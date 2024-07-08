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
                SearchBar(searchText: $searchText)
                    .padding()

            }
            ScrollView{
                AdminAppointmentsList(searchText: $searchText)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
            }
            
        }
        .background(Color.card)
        .navigationTitle("Appointments")
    }
}





#Preview {
    AdminAppointments()
}
