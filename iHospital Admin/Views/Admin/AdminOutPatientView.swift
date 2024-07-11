//
//  AdminOutPatientView.swift
//  iHospital Admin
//
//  Created by Aditya on 06/07/24.
//

import SwiftUI

struct AdminOutPatientView: View {
    @StateObject var patientViewModel = PatientViewModel()
    
    @State var searchtext = ""

    var body: some View {
        VStack {
            if patientViewModel.isLoading {
                Spacer()
                ProgressView().scaleEffect(2)
                Spacer()
            } else if patientViewModel.patients.isEmpty {
                Spacer()
                Text("No patients found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color(.systemGray))
                Spacer()
            } else {
                Table(patientViewModel.patients) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Gender", value: \.gender.id.capitalized)
                    TableColumn("Phone No.", value: \.phoneNumber.string)
                    TableColumn("Address", value: \.address)
                }.refreshable {
                    patientViewModel.fetchPatients(showLoader: false)
                }
            }
        }.searchable(text: $searchtext)
    }
}

#Preview {
    AdminOutPatientView()
}
