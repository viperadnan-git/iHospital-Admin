//
//  LabTestView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 14/07/24.
//

import SwiftUI
import PDFKit
import UIKit
import VisionKit
import AVKit

struct LabTestView: View {
    let testId: Int
    @State private var sampleID: String = ""
    @State private var sampleIDError: String?
    
    @State private var selectedPDFURL: URL?
    @State private var isShowingPDF = false
    @State private var isShowingPDFPreview = false
    @State private var isSavingSampleID = false
    @State private var isShowingDocumentPicker = false
    @State private var isShowingScanner = false
    @State private var isRequestingCameraPermission = false
    @State private var isUploading = false
    
    @EnvironmentObject private var labTechViewModel: LabTechViewModel
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    var body: some View {
        if let test = labTechViewModel.labTests.first(where: { $0.id == testId }) {
            HStack {
                PatienDetailsColumn(patient: test.appointment.patient)
                    .accessibilityLabel("Patient details")
                
                VStack(alignment: .leading) {
                    Form {
                        Section(header: Text("Lab Test Information")) {
                            HStack {
                                Text("Test ID")
                                Spacer()
                                Text("\(test.id)")
                                    .accessibilityLabel("Test ID")
                                    .accessibilityValue("\(test.id)")
                            }
                            HStack {
                                Text("Test Name")
                                Spacer()
                                Text(test.test.name)
                                    .accessibilityLabel("Test Name")
                                    .accessibilityValue(test.test.name)
                            }
                            HStack {
                                Text("Test Date")
                                Spacer()
                                Text(test.appointment.date, style: .date)
                                    .accessibilityLabel("Test Date")
                            }
                            
                            if let sampleID = test.sampleID {
                                HStack {
                                    Text("Sample ID")
                                    Spacer()
                                    Text(sampleID)
                                        .accessibilityLabel("Sample ID")
                                        .accessibilityValue(sampleID)
                                }
                            }
                            
                            if test.reportPath != nil {
                                HStack {
                                    Text("Report")
                                    Spacer()
                                    Button {
                                        isShowingPDF.toggle()
                                    } label: {
                                        Text(test.reportName)
                                            .multilineTextAlignment(.trailing)
                                            .accessibilityLabel("Report")
                                            .accessibilityHint("Tap to view the report")
                                    }
                                    .buttonStyle(.borderless)
                                    .sheet(isPresented: $isShowingPDF) {
                                        LabTestPDFView(test: test)
                                    }
                                }
                            }
                        }
                        
                        if test.sampleID == nil {
                            Section(header: Text("Sample Information")) {
                                TextField("Sample ID", text: $sampleID)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.allCharacters)
                                    .onChange(of: sampleID) { _ in validateSampleID() }
                                    .overlay(validationIcon(for: sampleIDError), alignment: .trailing)
                                    .accessibilityLabel("Sample ID input")
                                    .accessibilityHint("Enter the sample ID for this test.")
                                
                                HStack {
                                    Spacer()
                                    Button {
                                        updateSampleID(test: test, sampleID: sampleID)
                                    } label: {
                                        HStack {
                                            Image(systemName: "barcode")
                                            Text("Save Sample ID")
                                        }
                                    }
                                    .buttonStyle(.borderless)
                                    .disabled(isSavingSampleID || sampleIDError != nil)
                                    .accessibilityLabel("Save Sample ID")
                                    .accessibilityHint("Tap to save the entered sample ID.")
                                }
                            }
                        }
                        
                        if test.reportPath == nil {
                            Section(header: Text("Test Report")) {
                                if let selectedPDFURL = selectedPDFURL {
                                    HStack {
                                        Image(systemName: "doc.text")
                                            .accessibilityLabel("PDF Document")
                                        Text(selectedPDFURL.lastPathComponent)
                                            .accessibilityLabel("Selected PDF")
                                            .accessibilityValue(selectedPDFURL.lastPathComponent)
                                        Spacer()
                                        Button(action: {
                                            isShowingPDFPreview = true
                                        }) {
                                            Image(systemName: "eye")
                                                .accessibilityLabel("Preview PDF")
                                                .accessibilityHint("Tap to preview the selected PDF.")
                                        }
                                        .sheet(isPresented: $isShowingPDFPreview) {
                                            PDFKitRepresentedView(selectedPDFURL)
                                                .edgesIgnoringSafeArea(.all)
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        if isUploading {
                                            ProgressView()
                                                .accessibilityLabel("Uploading")
                                                .accessibilityHint("The report is being uploaded.")
                                        } else {
                                            Button {
                                                uploadReport(test: test, pdfURL: selectedPDFURL)
                                            } label: {
                                                HStack {
                                                    Image(systemName: "arrow.up.doc")
                                                    Text("Upload Report")
                                                }
                                            }
                                            .buttonStyle(.borderless)
                                            .disabled(isUploading)
                                            .accessibilityLabel("Upload Report")
                                            .accessibilityHint("Tap to upload the selected report.")
                                        }
                                    }
                                }
                                
                                HStack {
                                    Spacer()
                                    Button {
                                        isShowingDocumentPicker = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "square.and.arrow.up.fill")
                                            Text("Select from File")
                                        }
                                    }
                                    .buttonStyle(.borderless)
                                    .disabled(isUploading)
                                    .accessibilityLabel("Select PDF from File")
                                    .accessibilityHint("Tap to select a PDF file from your device.")
                                    .sheet(isPresented: $isShowingDocumentPicker) {
                                        DocumentPickerView { result in
                                            switch result {
                                            case .success(let url):
                                                print("Selected PDF URL: \(url)")
                                                selectedPDFURL = url
                                            case .failure(let error):
                                                errorAlertMessage.message = error.localizedDescription
                                            }
                                        }
                                    }
                                    Divider()
                                    Button {
                                        requestCameraPermissions {
                                            isShowingScanner = true
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "camera.fill")
                                            Text("Scan Report")
                                        }
                                    }
                                    .buttonStyle(.borderless)
                                    .disabled(isUploading || isRequestingCameraPermission)
                                    .accessibilityLabel("Scan Report")
                                    .accessibilityHint("Tap to scan a report using the camera.")
                                    .sheet(isPresented: $isShowingScanner) {
                                        DocumentScannerView { result in
                                            switch result {
                                            case .success(let url):
                                                print("Scanned document URL: \(url)")
                                                selectedPDFURL = url
                                            case .failure(let error):
                                                errorAlertMessage.message = error.localizedDescription
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            // Potentially add content or functionality here if needed
                        }
                    }
                }
            }
            .errorAlert(errorAlertMessage: errorAlertMessage)
            .accessibilityLabel("Lab Test View")
            .accessibilityHint("Displays detailed information about the selected lab test.")
        } else {
            VStack {
                Spacer()
                Text("No test found with ID \(testId)")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .accessibilityLabel("No Test Found")
                    .accessibilityHint("No lab test details are available for the provided ID.")
                Spacer()
            }
        }
    }
    
    private func requestCameraPermissions(completion: @escaping () -> Void) {
        isRequestingCameraPermission = true
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                isRequestingCameraPermission = false
                if granted {
                    completion()
                } else {
                    showSettingsAlert()
                }
            }
        }
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "Camera Access Needed", message: "Please enable camera access in settings to scan documents.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func validateSampleID() {
        if sampleID.isEmpty {
            sampleIDError = "Sample ID is required."
        } else if sampleID.count > 25 {
            sampleIDError = "Sample ID must not exceed 25 characters."
        } else {
            sampleIDError = nil
        }
    }
    
    func validationIcon(for error: String?) -> some View {
        Group {
            if let error = error {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .popover(isPresented: .constant(true)) {
                        Text(error).padding()
                    }
            }
        }
    }
    
    func updateSampleID(test: LabTest, sampleID: String) {
        validateSampleID()
        
        guard sampleIDError == nil else {
            return
        }
        
        Task {
            isSavingSampleID.toggle()
            defer {
                isSavingSampleID.toggle()
            }
            
            do {
                try await labTechViewModel.updateSampleID(test: test, sampleID: sampleID)
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
    
    func uploadReport(test: LabTest, pdfURL: URL) {
        Task {
            isUploading = true
            defer {
                isUploading = false
            }
            do {
                try await labTechViewModel.uploadReport(test: test, filePath: pdfURL)
            } catch {
                errorAlertMessage.message = error.localizedDescription
            }
        }
    }
}

#Preview {
    LabTestView(testId: 1)
        .environmentObject(LabTechViewModel())
}
