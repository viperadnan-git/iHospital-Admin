//
//  AdminPatientView.swift
//  iHospital Admin
//
//  Created by Aditya on 06/07/24.
//

import SwiftUI

struct AdminPatientView: View {
    @State var selectedSide = "OutPatient"
    
    var body: some View {
        
        VStack{
            Picker("Choose side", selection: $selectedSide){
                Text("InPatient").tag("InPatient")
                Text("OutPatient").tag("OutPatient")
            }
            .pickerStyle(.segmented)
            .colorMultiply(Color(.systemGray))
            .foregroundColor(Color(.systemGray))
            .frame(maxWidth: 400)
            
            if selectedSide == "OutPatient"{
                AdminOutPatientView()
            }
            else{
                AdminInPatientView()
            }
            
            
        }
        .navigationTitle("Patients")
    
    }
}

#Preview {
    AdminPatientView()
}
