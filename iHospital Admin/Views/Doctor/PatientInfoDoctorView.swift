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
            ScrollView {
                HStack(spacing: 20) {

                    VStack(alignment: .leading, spacing: 50) {
                        Text("Personal Info")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, -10)

                        VStack {
                            VStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                
                                Text(patient.name)
                                    .foregroundColor(.secondary)
                                    .font(.largeTitle)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 10)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        Spacer()

                        Group {
                            InfoRow(label: "Blood Group", value: patient.bloodGroup.rawValue)
                            InfoRowStringInt(label: "Phone Number", value: (patient.phoneNumber))
                            InfoRow(label: "Date of Birth", value: DateFormatter.localizedString(from: patient.dateOfBirth, dateStyle: .medium, timeStyle: .none))
                            InfoRow(label: "Height", value: "\(patient.height ?? 0) cms")
                            InfoRow(label: "Weight", value: "\(patient.weight ?? 0) kgs")
                            InfoRow(label: "Address", value: patient.address)
                        }
                    }
                    .padding(40)
                    .frame(width: geometry.size.width * 0.35)
                    .background(.accent)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    // Right-side part with medical history and test results
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Medical History")
                                    .font(.largeTitle)
                                Spacer()
                                Button(action: {
                                    showingModal.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("New Precaution")
                                    }
                                }
                                .sheet(isPresented: $showingModal) {
                                    AddPrecautionModalView(
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
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(.accent)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        
                        VStack(alignment: .leading) {
                            Text("Test Results")
                                .font(.largeTitle)
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
                                        .frame(width: 250) // Adjust width to fit your layout
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(Color(.accent))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    .frame(width: geometry.size.width * 0.6)
                }
                .padding()
            }
        }
        .navigationTitle("Dashboard")
    }
}

struct AddPrecautionModalView: View {
    @Binding var isPresented: Bool
    @Binding var newNote: String
    @Binding var showDocumentPicker: Bool
    @Binding var documentData: Data?
    var patient: Patient
    @State private var canvasView = PKCanvasView()
    @State private var canvasImage: UIImage? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("New Precaution")
                .font(.title)
                .bold()
            
            Text("Type Note:")
                .font(.headline)
            
            TextField("Enter note", text: $newNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom)
            
            Text("Write with Pencil:")
                .font(.headline)
            
            DrawingCanvasView(canvasView: $canvasView, canvasImage: $canvasImage)
                .frame(height: 200)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)
            
            Button(action: {
                showDocumentPicker.toggle()
            }) {
                HStack {
                    Image(systemName: "doc.text")
                    Text("Upload PDF or Report")
                }
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPickerView(documentData: $documentData)
            }

            Spacer()

            HStack {
                Button(action: {
                    // Process and save the handwritten note (canvasImage)
                    if (canvasImage?.pngData()) != nil {
                        // Save imageData along with the typed note
                    }
                    // Add note to patient's medical history
                    // Save documentData if available
                    isPresented = false
                }) {
                    Text("Add")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue) // Use the color of "New Precaution" button
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.vertical)
        }
        .padding()
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
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.bottom, 8)
            
            // Document preview
            if let data = documentData {
                DocumentPreviewView(data: data)
                    .frame(height: 80) // Adjusted height for smaller preview
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(height: 80) // Adjusted height for placeholder
                    .cornerRadius(10)
            }

            Spacer()

            HStack(spacing: 8) {
                Button(action: {
                    // View document action
                }) {
                    Text("View")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
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
        .padding(12) // Increased padding around the card
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 5)
        .frame(width: 250) // Fixed width for consistent card size
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

struct InfoRowStringInt: View {
    var label: String
    var value: Int
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
            Spacer()
            Text("\(value)")
        }
    }
}

struct InfoRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
        }
    }
}

struct PatientInfoDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        PatientInfoDoctorView(patient: Patient(
            patientId: UUID(),
            userId: UUID(),
            name: "Nitin",
            phoneNumber: 79082293,
            bloodGroup: BloodGroup.ABPositive,
            dateOfBirth: Date(timeIntervalSince1970: 0), // Example date
            height: 173,
            weight: 75,
            address: "Subhas nagar satha, london"
        ))
    }
}
