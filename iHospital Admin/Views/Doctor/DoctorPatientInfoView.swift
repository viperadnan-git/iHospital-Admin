import SwiftUI
import PencilKit
import PDFKit

struct DoctorPatientInfoView: View {
    var patient: Patient
    @State private var showingModal = false
    @State private var documentData: Data? = nil
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 12) {
                Form {
                    Section {
                        VStack(alignment: .center, spacing: 20) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                            
                            Text(patient.name)
                                .font(.title)
                                .fontWeight(.bold)
                        }.frame(maxWidth: .infinity)
                            .padding()
                    }
                    
                    Section(header: Text("Patient's Information")) {
                        HStack {
                            Text("Age")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.dateOfBirth.age)
                        }
                        
                        HStack {
                            Text("Phone No.")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.phoneNumber.string)
                        }
                        
                        HStack {
                            Text("Height")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.height?.string ?? "Unknown")
                                .foregroundColor(patient.height == nil ? .gray : .primary)
                        }
                        
                        HStack {
                            Text("Weight")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.weight?.string ?? "Unknown")
                                .foregroundColor(patient.weight == nil ? .gray : .primary)
                        }
                        
                        HStack {
                            Text("Blood Group")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.bloodGroup.id)
                        }
                        
                        HStack {
                            Text("Address")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(patient.address)
                        }
                    }
                }
                
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Medical History")
                                .font(.title3)
                                .bold()
                            Spacer()
                            Button(action: {
                                showingModal.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("New Prescription").bold()
                                }
                            }
                            .sheet(isPresented: $showingModal) {
                                DoctorAddPatientMedicalRecordView(
                                    isPresented: $showingModal,
                                    patient: patient
                                )
                            }
                        }
                        
                        // Horizontal scroll view for medical history
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<3) { index in
                                    MedicalRecordCardView(
                                        title: "Apollo Hospital",
                                        date: "19/07/2024",
                                        documentData: documentData
                                    )
                                    .frame(width: 250)
                                    .cornerRadius(10)
                                    .padding(.vertical)
                                    
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("Test Reports")
                            .font(.title3)
                            .bold()
                        
                        // Horizontal scroll view for test results
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<4) { index in
                                    MedicalRecordCardView(
                                        title: "Blood Test Report",
                                        date: "19/07/2024",
                                        documentData: documentData
                                    )
                                    .frame(width: 250)
                                    .cornerRadius(10)
                                    .padding(.vertical)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.56)
            }
        }
        .navigationTitle("\(patient.name)'s Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
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
        .background(Color(.systemGray6))
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
        DoctorPatientInfoView(patient: Patient.sample)
    }
}




