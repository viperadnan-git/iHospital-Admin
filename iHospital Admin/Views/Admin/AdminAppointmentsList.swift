//
//  AdminAppointmentsList.swift
//  iHospital Admin
//
//  Created by Aditya on 04/07/24.
//

import SwiftUI

struct AdminAppointmentsList: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            HStack{
                SearchBar()
                    .padding()
                DatePicker("", selection: $selectedDate,displayedComponents: .date)
                    .labelsHidden()
                    .padding()
                
//                    .frame(maxWidth: .infinity)

            }
            ScrollView{
                
                AppointmentsList()
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
