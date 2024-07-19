//
//  AdminInPatientView.swift
//  iHospital Admin
//
//  Created by Aditya on 06/07/24.
//

import SwiftUI

struct Patient1: Identifiable {
    var id = UUID()
    var patientID: Int
    var name: String
    var mobile: String
    var admittedDate: String
    var bedNumber: String
    var doctor: String
    var status: String
    var statusColor: Color
}

struct AdminInPatientView: View {
    @State var searchtext = ""
    
    let patients = [
        Patient1(patientID: 341, name: "Amit Verma", mobile: "+91 XXXXXXXXXX", admittedDate: "24/06/2024", bedNumber: "C43", doctor: "Dr. Harry Singh", status: "Admitted", statusColor: .blue),
        Patient1(patientID: 342, name: "Rahul Sharma", mobile: "+91 XXXXXXXXXX", admittedDate: "24/06/2024", bedNumber: "G56", doctor: "Dr. Harry Singh", status: "Admitted", statusColor: .blue),
        Patient1(patientID: 343, name: "Rohit Kumar", mobile: "+91 XXXXXXXXXX", admittedDate: "24/06/2024", bedNumber: "C56", doctor: "Dr. Harry Singh", status: "Discharged", statusColor: .green)
    ]
    
    var body: some View {
        VStack {
            Table(patients) {
                TableColumn("Patient ID") { patient in
                    Text("\(patient.patientID)")
                        .accessibilityLabel("Patient ID")
                        .accessibilityValue("\(patient.patientID)")
                }
                TableColumn("Patient Name") { patient in
                    Text(patient.name)
                        .accessibilityLabel("Patient Name")
                        .accessibilityValue(patient.name)
                }
                TableColumn("Mobile no.") { patient in
                    Text(patient.mobile)
                        .accessibilityLabel("Mobile Number")
                        .accessibilityValue(patient.mobile)
                }
                TableColumn("Admitted Date") { patient in
                    Text(patient.admittedDate)
                        .accessibilityLabel("Admitted Date")
                        .accessibilityValue(patient.admittedDate)
                }
                TableColumn("Bed no.") { patient in
                    Text(patient.bedNumber)
                        .accessibilityLabel("Bed Number")
                        .accessibilityValue(patient.bedNumber)
                }
                TableColumn("Doctor") { patient in
                    Text(patient.doctor)
                        .accessibilityLabel("Doctor")
                        .accessibilityValue(patient.doctor)
                }
                TableColumn("Status") { patient in
                    HStack {
                        Circle()
                            .fill(patient.statusColor)
                            .frame(width: 10, height: 10)
                        Text(patient.status)
                            .accessibilityLabel("Status")
                            .accessibilityValue(patient.status)
                    }
                }
            }
            .padding(.leading, 10)
        }
        .searchable(text: $searchtext)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("In Patients View")
        .accessibilityHint("Displays the list of in patients")
    }
}

#Preview {
    AdminInPatientView()
}
