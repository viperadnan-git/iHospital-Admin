//
//  PatienDetailsColumn.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 09/07/24.
//

import SwiftUI

struct PatienDetailsColumn: View {
    var patient: Patient
    @StateObject var errorAlertMessage = ErrorAlertMessage()
    
    var body: some View {
        Form {
            Section {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding()
            }.frame(maxWidth: .infinity, alignment: .center)
            
            Section(header: Text("Doctor Details")) {
                Text(patient.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)

                HStack {
                    Text("Gender")
                    Spacer()
                    Text(patient.gender.id.capitalized)
                }
                HStack {
                    Text("Phone")
                    Spacer()
                    Text(patient.phoneNumber.string)
                }
                HStack {
                    Text("Age")
                    Spacer()
                    Text(patient.dateOfBirth.yearsSince.string)
                }
                
                HStack {
                    Text("Blood Group")
                    Spacer()
                    Text(patient.bloodGroup.id)
                }
                
                HStack {
                    Text("Height")
                    Spacer()
                    if let height = patient.height {
                        Text("\(height, specifier: "%.2f") cm")
                    } else {
                        Text("Unknown").foregroundStyle(Color.gray)
                    }
                }
                HStack {
                    Text("Weight")
                    Spacer()
                    if let weight = patient.weight {
                        Text("\(weight, specifier: "%.2f") kg")
                    } else {
                        Text("Unknown")
                    }
                }
            }
        }.errorAlert(errorAlertMessage: errorAlertMessage)
    }
}

#Preview {
    PatienDetailsColumn(patient: Patient.sample)
}
