//
//  AdminAppointmentsList.swift
//  iHospital Admin
//
//  Created by Aditya on 04/07/24.
//

import SwiftUI

struct AdminAppointmentsList: View {
    @State private var selectedDate = Date()
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            HStack{
                SearchBar(searchText: $searchText)
                    .padding()
                DatePicker("", selection: $selectedDate,displayedComponents: .date)
                    .labelsHidden()
                    .padding()
                
//                    .frame(maxWidth: .infinity)

            }
            ScrollView{
                
                AppointmentsList(searchText: $searchText)
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
    AdminAppointmentsList()
}
