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
            } else {
                CenterSpinner()
                    
            }
        }.onAppear {
            Task {
                do {
                    let url = try await test.downloadReport()
                    reportPath = url
                } catch {
                    errorAlertMessage.message = error.localizedDescription
                }
            }
        }.errorAlert(errorAlertMessage: errorAlertMessage)
    }
}

#Preview {
    LabTestPDFView(test: LabTest.sample)
}
