//
//  LabTestDetailView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 17/07/24.
//

import SwiftUI

struct LabTestDetailView: View {
    var labTest: LabTest
    
    @Environment(\.dismiss) var dismiss
    
    @State private var reportURL: URL? = nil
    @State private var isLoading: Bool = false
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to load report")
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Lab Test Information").accessibilityAddTraits(.isHeader)) {
                    HStack {
                        Text("Test Name")
                        Spacer()
                        Text(labTest.test.name)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Test Name")
                    .accessibilityValue(labTest.test.name)
                    
                    HStack {
                        Text("Doctor")
                        Spacer()
                        Text(labTest.appointment.doctor.name)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Doctor")
                    .accessibilityValue(labTest.appointment.doctor.name)
                    
                    HStack {
                        Text("Test Date")
                        Spacer()
                        Text(labTest.appointment.date.dateString)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Test Date")
                    .accessibilityValue(labTest.appointment.date.dateString)
                }
                
                Section(header: Text("Test Status").accessibilityAddTraits(.isHeader)) {
                    LabTestStatusIndicator(status: labTest.status)
                        .accessibilityElement()
                        .accessibilityLabel("Test Status")
                        .accessibilityValue(labTest.status.rawValue.capitalized)
                }
                
                if labTest.status == .completed {
                    Section(header: Text("Test Report").accessibilityAddTraits(.isHeader)) {
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .accessibilityLabel("Loading")
                                .accessibilityHint("Fetching the report")
                        } else if let url = reportURL {
                            PDFKitRepresentedView(url)
                                .frame(height: 650)
                                .accessibilityLabel("Lab Test Report")
                        } else {
                            Text("Failed to load report.")
                                .foregroundColor(.red)
                                .accessibilityLabel("Failed to load report")
                                .accessibilityHint("Unable to fetch the report")
                        }
                    }
                    .onAppear {
                        fetchReport()
                    }
                }
            }
            .navigationTitle("Lab Test Report")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            }
            .accessibilityLabel("Close")
            .accessibilityHint("Close the lab test report view"))
            .errorAlert(errorAlertMessage: errorAlertMessage)
        }
    }
    
    private func fetchReport() {
        Task {
            isLoading = true
            do {
                let url = try await labTest.downloadReport()
                reportURL = url
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    LabTestDetailView(labTest: LabTest.sample)
}
