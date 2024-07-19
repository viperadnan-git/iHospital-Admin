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
        VStack {
            Picker("Choose side", selection: $selectedSide) {
                Text("In Patient").tag("InPatient")
                Text("Out Patient").tag("OutPatient")
            }
            .pickerStyle(.segmented)
            .colorMultiply(Color(.systemGray))
            .foregroundColor(Color(.systemGray))
            .frame(maxWidth: 400)
            .accessibilityLabel("Patient Type Picker")
            .accessibilityHint("Select the type of patient view")
            .accessibilityValue(selectedSide == "OutPatient" ? "Out Patient" : "In Patient")
            
            if selectedSide == "OutPatient" {
                AdminOutPatientView()
                    .accessibilityLabel("Out Patient View")
                    .accessibilityHint("Shows the list of out patients")
            } else {
                AdminInPatientView()
                    .accessibilityLabel("In Patient View")
                    .accessibilityHint("Shows the list of in patients")
            }
        }
        .navigationTitle("Patients")
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    AdminPatientView()
}
