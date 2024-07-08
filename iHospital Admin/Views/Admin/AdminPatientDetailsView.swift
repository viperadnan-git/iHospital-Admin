//
//  AdminPatientDetailsView.swift
//  iHospital Admin
//
//  Created by Aditya on 07/07/24.
//

import SwiftUI

struct AdminPatientDetailsView: View {
    var patient:Patient
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "person")
                        .resizable()
                        .frame(maxWidth: 100,maxHeight: 100)
                        .padding()
                    VStack(alignment: .leading){
                        Text("\(patient.name)").font(.title)
                            .bold()
                        Text("\(patient.userId)").font(.system(size: 12))
                        Text("Age: \(calculateAge(from: patient.dateOfBirth))")
                        Text("Phone No:  \(patient.phoneNumber)")
                        Text("Address: \(patient.address)")
                    }
                    .padding()
                    Divider()
                    VStack(alignment: .leading){
                        Text("Other Info").font(.title3)
                            .bold()
                        Text("Blood Group: \(patient.bloodGroup)")
                        Text("Height: \(patient.height ?? 00)")
                        Text("Weight: \(patient.weight ?? 00)")
                    }
                    .padding()

                }
                .frame(maxWidth: .infinity,maxHeight: 200,alignment: .leading)
                    .background(Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack{
                    Text("Billing History").font(.title2).bold().frame(maxWidth: .infinity,alignment: .leading)
                        BillingList(patient: patient)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                    
              
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                .padding()
                .background(Color.card)
            }.navigationTitle("Patient Details")
                    .navigationBarTitleDisplayMode(.inline)
                .padding()
        }
        
    }
}


struct BillingList:View {
    var patient:Patient
    var body: some View {
        LazyVStack{
            HStack{
                Text("Bill No.").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Patient ID").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Patient Name").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Appointment Date").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Doctor").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
                Text("Payment Mode").frame(maxWidth: .infinity,alignment: .leading)
                    .bold()
       }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding()
            
            ForEach(0..<10){_ in
                BillingRow(patient: patient)
                Divider()
            }
            
        }
    }
}

struct BillingRow:View {
    var patient:Patient
    var body: some View {

            HStack{
                Text("Bill No.").frame(maxWidth: .infinity,alignment: .leading)
                Text("\(patient.userId)").frame(maxWidth: .infinity,alignment: .leading)
                Text("\(patient.name)").frame(maxWidth: .infinity,alignment: .leading)
                Text("Appointment Date").frame(maxWidth: .infinity,alignment: .leading)
                Text("Doctor").frame(maxWidth: .infinity,alignment: .leading)
                Text("Cash").frame(maxWidth: .infinity,alignment: .leading)
            }
            .padding()

        
    }
}

//#Preview {
//    AdminPatientDetailsView()
//}
