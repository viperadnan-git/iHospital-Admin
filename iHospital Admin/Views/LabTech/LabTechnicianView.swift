//
//  LabTechnicianView.swift
//  iHospital Admin
//
//  Created by Aditya on 13/07/24.
//

import SwiftUI

struct LabTechnicianView: View {
    @StateObject private var labTechViewModel = LabTechViewModel()
    
    @StateObject var errorAlertMesssage = ErrorAlertMessage(title: "Failed to load")
    
    var body: some View {
        NavigationStack {
            
            if labTechViewModel.isLoading {
                CenterSpinner()
                    .accessibilityLabel("Loading")
                    .accessibilityHint("Fetching lab technician data.")
            } else {
                VStack {
                    HStack(spacing: 16) {
                        LabTechCard(
                            title: String(labTechViewModel.labTests.count),
                            subtitle: "Total Tests",
                            color: .accent
                        )
                        .accessibilityLabel("Total Tests")
                        .accessibilityValue("\(labTechViewModel.labTests.count)")
                        
                        ForEach(LabTestStatus.allCases, id: \.self) { status in
                            if let count = labTechViewModel.statusCounts[status] {
                                LabTechCard(
                                    title: count.string,
                                    subtitle: status.rawValue,
                                    color: status.color
                                )
                                .accessibilityLabel("\(status.rawValue) Count")
                                .accessibilityValue(count.string)
                            } else {
                                LabTechCard(
                                    subtitle: status.rawValue,
                                    color: status.color
                                )
                                .accessibilityLabel("\(status.rawValue) Count")
                                .accessibilityValue("0")
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        Text("Lab Tests")
                            .font(.title)
                            .bold()
                            .padding()
                            .accessibilityLabel("Lab Tests")
                        
                        Spacer()
                        
                        NavigationLink(destination: LabTechTable()) {
                            Text("View All")
                                .font(.subheadline)
                                .padding()
                                .foregroundColor(.accentColor)
                                .accessibilityLabel("View All Lab Tests")
                                .accessibilityHint("Tap to view all lab tests.")
                        }
                    }
                    .padding(.horizontal)
                    
                    if labTechViewModel.labTests.isEmpty {
                        Spacer()
                        Text("No lab tests")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .accessibilityLabel("No Lab Tests")
                            .accessibilityHint("No lab tests are currently available.")
                        Spacer()
                    } else {
                        Table(labTechViewModel.labTests) {
                            TableColumn("Name", value: \.patient.name)
                            TableColumn("Gender", value: \.patient.gender.id.capitalized)
                            TableColumn("Age", value: \.patient.dateOfBirth.ago)
                            TableColumn("Test", value: \.test.name)
                            TableColumn("Status") { test in
                                LabTestStatusIndicator(status: test.status)
                                    .accessibilityLabel("Test Status")
                                    .accessibilityValue(test.status.rawValue)
                            }
                            TableColumn("") { test in
                                NavigationLink(destination: LabTestView(testId: test.id).environmentObject(labTechViewModel)) {
                                    Image(systemName: "chevron.forward")
                                        .accessibilityLabel("Navigate to Test Details")
                                        .accessibilityHint("Tap to view details of the test.")
                                }
                            }
                            .width(40)
                        }
                        .refreshable {
                            labTechViewModel.updateLabTests(showLoader: false)
                        }
                        .errorAlert(errorAlertMessage: errorAlertMesssage)
                    }
                }
                .navigationTitle("Hello \(labTechViewModel.labTech?.name ?? "Lab Technician")")
                .navigationBarItems(
                    trailing: NavigationLink(destination: LabTechnicianProfile().environmentObject(labTechViewModel)) {
                        ProfileImage(userId: labTechViewModel.labTech?.userId?.uuidString ?? "")
                            .frame(width: 30, height: 30)
                            .accessibilityLabel("Lab Technician Profile")
                            .accessibilityHint("Tap to view your profile.")
                    }
                )
            }
        }
    }
}

struct LabTechCard: View {
    @State var title: String?
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack {
            if let title = title {
                Text(title)
                    .font(.largeTitle)
                    .bold()
                    .accessibilityLabel("Title")
                    .accessibilityValue(title)
            } else {
                ProgressView()
                    .padding()
                    .accessibilityLabel("Loading")
                    .accessibilityHint("Fetching data.")
            }
            
            Text(subtitle)
                .font(.subheadline)
                .textCase(.uppercase)
                .accessibilityLabel("Subtitle")
                .accessibilityValue(subtitle)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(color)
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}

#Preview {
    LabTechnicianView()
}
