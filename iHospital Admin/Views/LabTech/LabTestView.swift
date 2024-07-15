import SwiftUI
import PDFKit
import UIKit
import VisionKit
import AVKit

struct LabTestView: View {
    let testId: Int
    @State private var sampleID: String = ""
    @State private var sampleIDError: String?
    
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
                        }
                        
                        if test.sampleID == nil {
                            Section(header: Text("Sample Information")) {
                                TextField("Sample ID", text: $sampleID)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .onChange(of: sampleID) { _ in validateSampleID()}
                                    .overlay(Image.validationIcon(for: sampleIDError), alignment: .trailing)
                                
                                HStack {
                                    Spacer()
                                    Button {
                                        print("Sample ID: \(sampleID)")
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
                                HStack {
                                    Spacer()
                                    if isUploading {
                                        ProgressView()
                                    } else {
                                        Spacer()
                                        Button {
                                            isShowingDocumentPicker = true
                                        } label: {
                                            HStack {
                                                Image(systemName: "square.and.arrow.up.fill")
                                                Text("Upload Report")
                                            }
                                        }
                                        .buttonStyle(.borderless)
                                        .sheet(isPresented: $isShowingDocumentPicker) {
                                            LabDocumentPickerView { result in
                                                switch result {
                                                case .success(let url):
                                                    print("Selected PDF URL: \(url)")
                                                    isUploading = true
                                                    // Handle the PDF file URL
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
                                        .disabled(isRequestingCameraPermission)
                                        .sheet(isPresented: $isShowingScanner) {
                                            LabDocumentScannerView { result in
                                                switch result {
                                                case .success(let url):
                                                    print("Scanned document URL: \(url)")
                                                    isUploading = true
                                                    // Handle the scanned document URL
                                                case .failure(let error):
                                                    errorAlertMessage.message = error.localizedDescription
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
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
}

struct LabDocumentPickerView: UIViewControllerRepresentable {
    var completionHandler: (Result<URL, Error>) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: LabDocumentPickerView

        init(_ parent: LabDocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.completionHandler(.failure(NSError(domain: "DocumentPickerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No document was selected."])))
                return
            }
            parent.completionHandler(.success(url))
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.completionHandler(.failure(NSError(domain: "DocumentPickerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document picker was cancelled."])))
        }
    }
}

struct LabDocumentScannerView: UIViewControllerRepresentable {
    var completionHandler: (Result<URL, Error>) -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: LabDocumentScannerView

        init(_ parent: LabDocumentScannerView) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            guard scan.pageCount > 0 else {
                parent.completionHandler(.failure(NSError(domain: "ScannerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No document was scanned."])))
                controller.dismiss(animated: true)
                return
            }
            
            // Save the scanned document as a PDF
            let tempDir = FileManager.default.temporaryDirectory
            let tempURL = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("pdf")
            
            let pdfDocument = PDFDocument()
            
            for i in 0..<scan.pageCount {
                let pageImage = scan.imageOfPage(at: i)
                let pdfPage = PDFPage(image: pageImage)
                pdfDocument.insert(pdfPage!, at: i)
            }
            
            do {
                try pdfDocument.dataRepresentation()?.write(to: tempURL)
                parent.completionHandler(.success(tempURL))
            } catch {
                parent.completionHandler(.failure(error))
            }
            
            controller.dismiss(animated: true)
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.completionHandler(.failure(NSError(domain: "ScannerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Scanner was cancelled."])))
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.completionHandler(.failure(error))
            controller.dismiss(animated: true)
        }
    }
}

#Preview {
    LabTestView(testId: 1)
        .environmentObject(LabTechViewModel())
}
