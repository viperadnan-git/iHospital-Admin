//
//  LabTechnicianView.swift
//  iHospital Admin
//
//  Created by Aditya on 13/07/24.
//

import SwiftUI

struct LabTechnicianView: View {
    @StateObject private var labTechViewModel = LabTechViewModel()
    
    @StateObject var errorAlertMesssage = ErrorAlertMessage(title: "Failed to laod")
    
    var body: some View {
        NavigationStack {
            
            if labTechViewModel.isLoading {
                CenterSpinner()
            } else {
                VStack {
                    HStack(spacing: 16) {
                        LabTechCard(title: String(labTechViewModel.labTests.count), subtitle: "Total Tests", color: .accent)
                        ForEach(LabTestStatus.allCases, id: \.self) { status in
                            if let count = labTechViewModel.statusCounts[status] {
                                LabTechCard(title: count.string, subtitle: status.rawValue, color: status.color)
                            } else {
                                LabTechCard(subtitle: status.rawValue, color: status.color)
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        Text("Lab Tests")
                            .font(.title)
                            .bold()
                            .padding()
                        Spacer()
                        NavigationLink(destination: LabTechTable()) {
                            Text("View All")
                                .font(.subheadline)
                                .padding()
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.horizontal)
                    
                    if labTechViewModel.labTests.isEmpty {
                        Spacer()
                        Text("No lab tests")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        Table(labTechViewModel.labTests) {
                            TableColumn("Name", value: \.patient.name)
                            TableColumn("Gender", value: \.patient.gender.id.capitalized)
                            TableColumn("Age", value: \.patient.dateOfBirth.ago)
                            TableColumn("Test", value: \.test.name)
                            TableColumn("Status") { test in
                                LabTestStatusIndicator(status: test.status)
                            }
                            TableColumn("") { test in
                                NavigationLink(destination: LabTestView(testId: test.id).environmentObject(labTechViewModel)) {
                                    Image(systemName: "chevron.forward")
                                }
                            }
                            .width(40)
                        }
                        .refreshable {
                            labTechViewModel.updateLabTests(showLoader: false)
                        }.errorAlert(errorAlertMessage: errorAlertMesssage)
                    }
                }
                
                .navigationTitle("Hello \(labTechViewModel.labTech?.name ?? "Lab Technician")")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            Task {
                                do {
                                    try await SupaUser.logout()
                                } catch {
                                    print(error)
                                }
                            }
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        }
                    }
                }
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
            } else {
                ProgressView()
                    .padding()
            }
            
            Text(subtitle)
                .font(.subheadline)
                .textCase(.uppercase)
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
