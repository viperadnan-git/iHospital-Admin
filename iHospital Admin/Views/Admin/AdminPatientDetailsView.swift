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
                        .padding(40)
                    VStack(alignment: .leading, spacing: 8){
                        Text("\(patient.name)").font(.title)
                            .bold()
                        Text("\(patient.userId)").font(.system(size: 12))
                        Text("Age: \(patient.dateOfBirth.age)")
                        Text("Phone No:  \(patient.phoneNumber.string)")
                        Text("Address: \(patient.address)")
                    }
                    .padding()
                    Divider().padding()
                    VStack(alignment: .leading, spacing: 8){
                        Text("Other Info").font(.title3)
                            .bold()
                        Text("Blood Group: \(patient.bloodGroup)")
                        Text("Height: \(patient.height ?? 00)")
                        Text("Weight: \(patient.weight ?? 00)")
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 220,alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                VStack{
                    Text("Billing History").font(.title2).bold().frame(maxWidth: .infinity,alignment: .leading)
                    BillingList(patient: patient)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    
                    
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                .padding()
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
                    
                Text("Patient Name").frame(maxWidth: .infinity,alignment: .leading)
                    
                Text("Appointment Date").frame(maxWidth: .infinity,alignment: .leading)
                    
                Text("Doctor").frame(maxWidth: .infinity,alignment: .leading)
            
                Text("Payment Mode").frame(maxWidth: .infinity,alignment: .leading)
                    
            }
            .font(.caption)
                .textCase(.uppercase)
                .foregroundColor(Color(.systemGray))
                .bold()
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
            Text("\(patient.firstName)").frame(maxWidth: .infinity,alignment: .leading)
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
