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
                Section(header: Text("Lab Test Information")) {
                    HStack {
                        Text("Test Name")
                        Spacer()
                        Text(labTest.test.name)
                    }
                    HStack {
                        Text("Doctor")
                        Spacer()
                        Text(labTest.appointment.doctor.name)
                    }
                    HStack {
                        Text("Test Date")
                        Spacer()
                        Text(labTest.appointment.date.dateString)
                    }
                }
                
                Section(header: Text("Test Status")) {
                    LabTestStatusIndicator(status: labTest.status)
                }
                
                if labTest.status == .completed {
                    Section(header: Text("Test Report")) {
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if let url = reportURL {
                            PDFKitRepresentedView(url)
                                .frame(height: 650)
                        } else {
                            Text("Failed to load report.")
                                .foregroundColor(.red)
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
            })
            .errorAlert(errorAlertMessage: errorAlertMessage)
        }
    }
    
    private func fetchReport() {
        Task {
            isLoading = true
            do {
                let url = try await labTest.downloadReport()
                reportURL = url;
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
