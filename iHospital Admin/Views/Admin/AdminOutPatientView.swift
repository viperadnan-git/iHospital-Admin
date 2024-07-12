//
//  AdminOutPatientView.swift
//  iHospital Admin
//
//  Created by Aditya on 06/07/24.
//

import SwiftUI

struct AdminOutPatientView: View {
    @StateObject var patientViewModel = PatientViewModel()
    
    @State var searchText = ""
    
    @State private var sortOrder = [ KeyPathComparator(\Patient.name, order: .forward)]
    
    var body: some View {
        VStack {
            if patientViewModel.isLoading {
                Spacer()
                ProgressView().scaleEffect(2)
                Spacer()
            } else if filteredPatients.isEmpty {
                Spacer()
                Text("No patients found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color(.systemGray))
                Spacer()
            } else {
                Table(filteredPatients,sortOrder: $sortOrder) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Gender", value: \.gender.id.capitalized)
                    TableColumn("Phone No.", value: \.phoneNumber.string)
                    TableColumn("Address", value: \.address).width(min: 300)
                    TableColumn("") { patient in
                        
                        HStack{
                            Spacer()
                            NavigationLink(destination: AdminPatientDetailsView(patient: patient)) {
                                Image(systemName: "info.circle")                        }
                        }
                    }
                }.refreshable {
                    patientViewModel.fetchPatients(showLoader: false)
                
                }
                .onChange(of: sortOrder) { neworder in
                    patientViewModel.patients.sort(using: neworder)
                    
                }
                
            }
        }.searchable(text: $searchText)
    }
    
    
    private var filteredPatients: [Patient] {
        if searchText.isEmpty {
            return patientViewModel.patients
        } else {
            return patientViewModel.patients.filter { patient in
                patient.name.lowercased().contains(searchText.lowercased())
                || patient.phoneNumber.string.lowercased().contains(searchText.lowercased())
                || patient.address.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
}

#Preview {
    AdminOutPatientView()
}
