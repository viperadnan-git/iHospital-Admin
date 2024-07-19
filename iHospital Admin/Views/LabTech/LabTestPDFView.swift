//
//  LabTestPDFView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import SwiftUI

struct LabTestPDFView: View {
    var test: LabTest
    @State var reportPath: URL? = nil
    
    @StateObject private var errorAlertMessage = ErrorAlertMessage(title: "Failed to load report")

    var body: some View {
        VStack {
            if let reportPath = reportPath {
                PDFKitRepresentedView(reportPath)
                    .accessibilityLabel("Lab Test Report")
                    .accessibilityHint("Displays the PDF report for the selected lab test.")
            } else {
                CenterSpinner()
                    .accessibilityLabel("Loading")
                    .accessibilityHint("Downloading the lab test report.")
            }
        }
        .onAppear {
            Task {
                do {
                    let url = try await test.downloadReport()
                    reportPath = url
                } catch {
                    errorAlertMessage.message = error.localizedDescription
                }
            }
        }
        .errorAlert(errorAlertMessage: errorAlertMessage)
        .accessibilityLabel("Lab Test PDF View")
        .accessibilityHint("View of the PDF report for the selected lab test.")
    }
}

#Preview {
    LabTestPDFView(test: LabTest.sample)
}
