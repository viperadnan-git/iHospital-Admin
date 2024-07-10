import SwiftUI
import PencilKit
import PDFKit

struct PatientInfoDoctorView: View {
    var patient: Patient
    @State private var showingModal = false
    @State private var newNote = ""
    @State private var showDocumentPicker = false
    @State private var documentData: Data? = nil

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 12) {
                
                // Personal Info Section
                VStack {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Personal Info")
                                .font(.largeTitle)
                                .bold()
                                .padding(.bottom, 10)
                                .foregroundColor(.primary)
                            
                            VStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding(.top,40)
                                
                                Text(patient.name)
                                    .foregroundColor(.primary)
                                    .font(.largeTitle)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 10)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                            
                            Group {
                                InfoRow(label: "Blood Group", value: patient.bloodGroup.rawValue)
                                InfoRowStringInt(label: "Phone Number", value: (patient.phoneNumber))
                                InfoRow(label: "Date of Birth", value: DateFormatter.localizedString(from: patient.dateOfBirth, dateStyle: .medium, timeStyle: .none))
                                InfoRow(label: "Height", value: "\(patient.height ?? 0) cms")
                                InfoRow(label: "Weight", value: "\(patient.weight ?? 0) kgs")
                                InfoRow(label: "Address", value: patient.address)
                            }
                            .padding(10)
                            .foregroundColor(.primary)
                        }
                        .padding(40)
                        
                    }
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.97)
                    .background(Color(uiColor: .systemBackground))
                    .foregroundColor(Color(uiColor: .label))
                    .cornerRadius(15)
                }
                
                // Right-side part with medical history and test results
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Medical History")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                            Spacer()
                            Button(action: {
                                showingModal.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("New Prescription").bold()
                                }
                                .foregroundColor(.primary)
                                
                                
                            }
                            .sheet(isPresented: $showingModal) {
                                AddPrescriptionModalView(
                                    isPresented: $showingModal,
                                    newNote: $newNote,
                                    showDocumentPicker: $showDocumentPicker,
                                    documentData: $documentData,
                                    patient: patient
                                )
                            }
                        }
                        .padding(.bottom, 10)
                        
                        // Horizontal scroll view for medical history
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<3) { index in
                                    MedicalRecordCardView(
                                        title: "Apollo Hospital",
                                        date: "19/07/2024",
                                        documentData: documentData
                                    )
                                    .frame(width: 250) // Adjust width to fit your layout
                                    .cornerRadius(10)
                                    .padding(.vertical)
                                    
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .foregroundColor(Color(uiColor: .label))
                    .cornerRadius(15)
                    
                    
                    VStack(alignment: .leading) {
                        Text("Test Results")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .padding(.bottom, 10)
                        
                        // Horizontal scroll view for test results
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<4) { index in
                                    MedicalRecordCardView(
                                        title: "Blood Test Report",
                                        date: "19/07/2024",
                                        documentData: documentData
                                    )
                                    .frame(width: 240)
                                    .cornerRadius(10)
                                    .padding(.vertical)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .foregroundColor(Color(uiColor: .label))
                    .cornerRadius(15)
//                    .background(Color(UIColor.secondarySystemBackground))

                    
                }
                .frame(width: geometry.size.width * 0.56)
            }
            .padding()
//            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .background(Color(UIColor.secondarySystemBackground))
        }
        .navigationTitle("Dashboard")
    }
}



struct AddPrescriptionModalView: View {
    @Binding var isPresented: Bool
    @Binding var newNote: String
    @Binding var showDocumentPicker: Bool
    @Binding var documentData: Data?
    var patient: Patient
    @State private var canvasView = PKCanvasView()
    @State private var canvasImage: UIImage? = nil
    @State private var medicines: [Medicine] = [Medicine()]
    @State private var labTests: [LabTestItem] = [LabTestItem()]

    let predefinedLabTests = ["Complete Blood Count", "Blood Sugar", "Lipid Profile", "Liver Function Test", "Kidney Function Test"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Type Note")) {
                    TextEditor(text: $newNote)
                        .frame(height: 150)
                        .padding(.horizontal, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(UIColor.separator), lineWidth: 1)
                        )
                }

                Section(header: Text("Diagnose")) {
                    DrawingCanvasView(canvasView: $canvasView, canvasImage: $canvasImage)
                        .frame(height: 200)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                }

                Section(header: Text("Medicines")) {
                    ForEach($medicines) { $medicine in
                        HStack {
                            TextField("Medicine Name", text: $medicine.name)
                            Spacer()
                            Picker("", selection: $medicine.dosage) {
                                Text("Once a day").tag(1)
                                Text("Twice a day").tag(2)
                                Text("Three times a day").tag(3)
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    Button(action: {
                        medicines.append(Medicine())
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Medicine")
                        }
                    }
                }

                Section(header: Text("Lab Tests")) {
                    ForEach($labTests) { $labTest in
                        HStack {
                            TextField("Lab Test Name", text: $labTest.name)
                            Spacer()
                            Menu {
                                ForEach(predefinedLabTests, id: \.self) { test in
                                    Button(action: {
                                        labTest.selectedTest = test
                                        labTest.name = test
                                    }) {
                                        Text(test)
                                    }
                                }
                            } label: {
                                Text(labTest.selectedTest.isEmpty ? "Select Test" : labTest.selectedTest)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    Button(action: {
                        labTests.append(LabTestItem())
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Lab Test")
                        }
                    }
                }
            }
            .navigationTitle("New Prescription")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Add") {
                // Process and save the handwritten note (canvasImage)
                if let imageData = canvasImage?.pngData() {
                    // Save imageData along with the typed note
                }
                // Add note to patient's medical history
                // Save documentData if available
                isPresented = false
            })
        }
    }
}


struct DrawingCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var canvasImage: UIImage?

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var documentData: Data?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            do {
                parent.documentData = try Data(contentsOf: url)
            } catch {
                print("Error reading document data: \(error)")
            }
        }
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}

struct MedicalRecordCardView: View {
    var title: String
    var date: String
    var documentData: Data?

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                    Text(date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            .padding(.bottom, 8)
            
            // Document preview
            if let data = documentData {
                DocumentPreviewView(data: data)
                    .frame(height: 80)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(height: 80)
                    .cornerRadius(10)
            }

            Spacer()

            HStack(spacing: 8) {
                Button(action: {
                   
                }) {
                    Text("View")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Download document action
                }) {
                    Text("Download")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(12)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .frame(width: 250)
    }
}

struct DocumentPreviewView: View {
    var data: Data

    var body: some View {
        if let pdfDocument = PDFDocument(data: data) {
            PDFViewWrapper(document: pdfDocument)
        } else if let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
        } else {
            Text("No Preview Available")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemGray5))
        }
    }
}

struct PDFViewWrapper: UIViewRepresentable {
    var document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}


struct PatientInfoDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        PatientInfoDoctorView(patient: Patient.sample)
    }
}




