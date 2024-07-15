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
                
                VStack(alignment: .leading) {
                    Form {
                        Section(header: Text("Lab Test Information")) {
                            HStack {
                                Text("Test ID")
                                Spacer()
                                Text("\(test.id)")
                            }
                            HStack {
                                Text("Test Name")
                                Spacer()
                                Text(test.name)
                            }
                            HStack {
                                Text("Test Date")
                                Spacer()
                                Text(test.appointment.date, style: .date)
                            }
                            
                            if let sampleID = test.sampleID {
                                HStack {
                                    Text("Sample ID")
                                    Spacer()
                                    Text(sampleID)
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
                                }
                            }
                        }
                        
                        if test.reportPath == nil {
                            Section(header: Text("Test Report")) {
                                if let selectedPDFURL = selectedPDFURL {
                                    HStack {
                                        Image(systemName: "doc.text")
                                        Text(selectedPDFURL.lastPathComponent)
                                        Spacer()
                                        Button(action: {
                                            isShowingPDFPreview = true
                                        }) {
                                            Image(systemName: "eye")
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
                            
                        }
                    }
                }
            }.errorAlert(errorAlertMessage: errorAlertMessage)
        } else {
            VStack {
                Spacer()
                Text("No test found with ID \(testId)")
                    .font(.headline)
                    .foregroundColor(.gray)
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
