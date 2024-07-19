//
//  LabTechTable.swift
//  iHospital Admin
//
//  Created by Aditya on 15/07/24.
//

import SwiftUI

struct LabTechTable: View {
    
    @StateObject private var labTechViewModel = LabTechViewModel()
    @State private var searchText: String = ""
    
    @StateObject var errorAlertMessage = ErrorAlertMessage(title: "Failed to load")
    
    var body: some View {
        
        if labTechViewModel.isLoading {
            CenterSpinner()
                .accessibilityLabel("Loading lab tests")
                .accessibilityHint("Please wait while the lab tests data is being loaded.")
        } else {
            Table(filteredLabTests) {
                TableColumn("Name", value: \.patient.name)
                TableColumn("Gender", value: \.patient.gender.id.capitalized)
                TableColumn("Age", value: \.patient.dateOfBirth.ago)
                TableColumn("Test", value: \.test.name)
                TableColumn("Status") { test in
                    LabTestStatusIndicator(status: test.status)
                        .accessibilityLabel("Status")
                        .accessibilityHint("The current status of the lab test.")
                }
                TableColumn("") { test in
                    NavigationLink(destination: LabTestView(testId: test.id).environmentObject(labTechViewModel)) {
                        HStack {
                            Image(systemName: "chevron.right")
                                .accessibilityLabel("Navigate")
                                .accessibilityHint("Tap to view details of this lab test.")
                        }
                    }
                }
                .width(40)
            }
            .searchable(text: $searchText)
            .navigationTitle("All Lab Tests")
            .refreshable {
                labTechViewModel.updateLabTests(showLoader: false)
            }
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .accessibilityLabel("Lab Tech Table")
            .accessibilityHint("Displays a list of all lab tests with their details.")
        }
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
                ||
                labTest.test.name.lowercased()
                    .contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    LabTechTable()
}
