//
//  LabTechTable.swift
//  iHospital Admin
//
//  Created by Aditya on 15/07/24.
//

import SwiftUI

struct LabTechTable: View {
    
    @StateObject private var labTechViewModel = LabTechViewModel()
    @State private var searchText:String = ""
    
    var body: some View {
        Table(filteredLabTests) {
            TableColumn("Name", value: \.patient.name)
            TableColumn("Gender",value: \.patient.gender.id.capitalized)
            TableColumn("Age", value: \.patient.dateOfBirth.ago)
            TableColumn("Status") { test in
                LabTestStatusIndicator(status: test.status)
            }
            //            TableColumn("") { test in
            //                NavigationLink(destination: LabTestView(testId: test.id)){
            //                    HStack{
            //                        Image(systemName: "chevron.right")
            //
            //                    }
            //                }
            //
            //            }.width(40)
        }.searchable(text: $searchText)
            .navigationTitle("All Lab Tests")
        
        
        
    }
    
    private var filteredLabTests: [LabTest] {
        if searchText.isEmpty {
            return labTechViewModel.labTests
        } else {
            return labTechViewModel.labTests.filter { labTest in
                labTest.patient.name.lowercased().contains(searchText.lowercased())
                ||
                labTest.patient.phoneNumber.string
                    .contains(searchText.lowercased())
            }
        }
    }
}
#Preview {
    LabTechTable()
}