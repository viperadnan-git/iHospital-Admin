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
            // Profile Image Section
            Section {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding()
                    .accessibility(label: Text("Patient Profile Picture"))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // Patient Details Section
            Section(header: Text("Patient Details")) {
                Text(patient.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                    .accessibility(label: Text("Patient Name"))

                HStack {
                    Text("Gender")
                        .accessibility(label: Text("Gender"))
                    Spacer()
                    Text(patient.gender.id.capitalized)
                        .accessibility(value: Text(patient.gender.id.capitalized))
                }

                HStack {
                    Text("Phone")
                        .accessibility(label: Text("Phone Number"))
                    Spacer()
                    Text(patient.phoneNumber.string)
                        .accessibility(value: Text(patient.phoneNumber.string))
                }

                HStack {
                    Text("Age")
                        .accessibility(label: Text("Age"))
                    Spacer()
                    Text(patient.dateOfBirth.yearsSince.string)
                        .accessibility(value: Text(patient.dateOfBirth.yearsSince.string))
                }
                
                HStack {
                    Text("Blood Group")
                        .accessibility(label: Text("Blood Group"))
                    Spacer()
                    Text(patient.bloodGroup.id)
                        .accessibility(value: Text(patient.bloodGroup.id))
                }

                HStack {
                    Text("Height")
                        .accessibility(label: Text("Height"))
                    Spacer()
                    if let height = patient.height {
                        Text("\(height, specifier: "%.2f") cm")
                            .accessibility(value: Text("\(height, specifier: "%.2f") cm"))
                    } else {
                        Text("Unknown")
                            .foregroundStyle(Color.gray)
                            .accessibility(value: Text("Unknown"))
                    }
                }
                
                HStack {
                    Text("Weight")
                        .accessibility(label: Text("Weight"))
                    Spacer()
                    if let weight = patient.weight {
                        Text("\(weight, specifier: "%.2f") kg")
                            .accessibility(value: Text("\(weight, specifier: "%.2f") kg"))
                    } else {
                        Text("Unknown")
                            .foregroundStyle(Color.gray)
                            .accessibility(value: Text("Unknown"))
                    }
                }
            }
        }
        .errorAlert(errorAlertMessage: errorAlertMessage)
    }
}

#Preview {
    PatienDetailsColumn(patient: Patient.sample)
}
